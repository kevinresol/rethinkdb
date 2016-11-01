package;

import rethinkdb.RethinkDB.r;
import rethinkdb.*;
import rethinkdb.reql.*;

using TestTools;
using rethinkdb.Response.ResponseTools;
using rethinkdb.reql.ReqlError;
using tink.CoreApi;

// @:build(Macro.build())
class Test {
	var conn:Connection;
	var tbl:Expr;
	public function new() {
		conn = r.connect();
		// tbl = r.table('default_test').orderBy(Field('a')).pluck(['a']);
		test();
	}
	
	function test() {
		r.expr(1).default_(2).run(conn).asAtom().assertAtom(1);
		r.expr(null).default_(2).run(conn).asAtom().assertAtom(2);
		r.expr([0, 1, 2]).do_(function(e:Expr) return e.append(3)).run(conn).asAtom().assertAtom([0, 1, 2, 3]);
		r.do_(1, 2, function(x:Expr, y:Expr) return x + y).run(conn).asAtom().assertAtom(3);
		r.do_(1).run(conn).asAtom().assertAtom(1);
		r.do_(1, 2, function(x:Expr) return x).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected function with 2 arguments but found function with 1 argument.'));
		r.do_(1, 2, 3, function(x:Expr, y:Expr) return x + y).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected function with 3 arguments but found function with 2 arguments.'));
		r.expr('abc').do_(function(v:Expr) return v.append(3)).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected type ARRAY but found STRING.'));
		r.expr('abc').do_(function(v:Expr) return v + 3).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected type STRING but found NUMBER.'));
		r.expr('abc').do_(function(v:Expr) return v.add('def')).add(3).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected type STRING but found NUMBER.'));
		r.expr(0).do_(function(a:Expr, b:Expr) return a + b).add(3).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected function with 1 argument but found function with 2 arguments.'));
		
		
		r.branch(true, 1, 2).run(conn).asAtom().assertAtom(1);
		r.branch(false, 1, 2).run(conn).asAtom().assertAtom(2);
		r.branch(1, 'c', false).run(conn).asAtom().assertAtom('c');
		r.branch(null, {}, []).run(conn).asAtom().assertAtom([]);
		// r.branch(r.db('test'), 1, 2).run(conn).asAtom().assertError(ReqlQueryLogicError('Expected type DATUM but found DATABASE:'));
		
		var tbl = r.table('tink_protocol');
		
		// tbl.insert([for(i in 0...3) {id:i, a:i}]).run(conn).asAtom().assertAtom({deleted: 0,replaced: 0,unchanged: 0,errors: 0,skipped: 0,inserted: 3});
	}
	
	
}