package ;

import deepequal.DeepEqual.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.response.*;

using RethinkDBApi;
using tink.CoreApi;

class RunTests {

	var conn:Connection;
	var tbl:Expr;
	
	static function main()
		new RunTests();
	
	public function new() {
		conn = r.connect();
		test();
	}
	
	var count = 0;
	var errors = [];
	
	function retain()
		count++;
		
	function release()
		if(--count == 0) {
			if(errors.length > 0) for(e in errors) trace(e);
			Sys.exit(errors.length);
		}
	
	function handle(s:Surprise<Noise, Error>) 
		s.handle(function(o) {
			switch o {
				case Success(_):
				case Failure(f): errors.push(f);
			}
			release();
		});
	
	function assertAtom<T>(v:T, e:Expr, ?pos:haxe.PosInfos) {
		retain();
		
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(ret): try {
				compare(ret, v);
				Success(Noise); 
			}catch(err:String) Failure(new Error(err, pos));
			case Failure(f): Failure(new Error('Unexpected error $f', pos));
		});
		
		handle(f);
	}
	
	function assertError(errName:String, message:String, e:Expr, ?pos:haxe.PosInfos) {
		retain();
		
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(_): Failure(new Error("Unexpected failure", pos));
			case Failure(f): try {
				var err:ReqlError = f.data;
				compare(errName, err.getName());
				compare(message, (err.getParameters()[0]:String).split('\n')[0]);
				Success(Noise);
			} catch(err:String) Failure(new Error(err, pos));
		});
		
		handle(f);
	}
	
	function test() {
		assertAtom(1, r.expr(1).default_(2));
		assertAtom(2, r.expr(null).default_(2));
		assertAtom([0, 1, 2, 3], r.expr([0, 1, 2]).do_(function(e:Expr) return e.append(3)));
		assertAtom(3, r.do_(1, 2, function(x:Expr, y:Expr) return x + y));
		assertAtom(1, r.do_(1));
		assertError('ReqlQueryLogicError', 'Expected function with 2 arguments but found function with 1 argument.', r.do_(1, 2, function(x:Expr) return x));
		assertError('ReqlQueryLogicError', 'Expected function with 3 arguments but found function with 2 arguments.', r.do_(1, 2, 3, function(x:Expr, y:Expr) return x + y));
		assertError('ReqlQueryLogicError', 'Expected type ARRAY but found STRING.', r.expr('abc').do_(function(v:Expr) return v.append(3)));
		assertError('ReqlQueryLogicError', 'Expected type STRING but found NUMBER.', r.expr('abc').do_(function(v:Expr) return v + 3));
		assertError('ReqlQueryLogicError', 'Expected type STRING but found NUMBER.', r.expr('abc').do_(function(v:Expr) return v.add('def')).add(3));
		assertError('ReqlQueryLogicError', 'Expected function with 1 argument but found function with 2 arguments.', r.expr(0).do_(function(a:Expr, b:Expr) return a + b).add(3));
		
		
		assertAtom(1, r.branch(true, 1, 2));
		assertAtom(2, r.branch(false, 1, 2));
		assertAtom('c', r.branch(1, 'c', false));
		assertAtom([], r.branch(null, {}, []));
		assertError('ReqlQueryLogicError', 'Expected type DATUM but found DATABASE:', r.branch(r.db('test'), 1, 2));
		
		var tbl = r.table('tink_protocol');
		
		// tbl.insert([for(i in 0...3) {id:i, a:i}]).run(conn).asAtom().assertAtom({deleted: 0,replaced: 0,unchanged: 0,errors: 0,skipped: 0,inserted: 3});
	}

  
}