package;

import deepequal.DeepEqual.*;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.response.*;

using rethinkdb.response.Response;
using tink.CoreApi;

class TestBase {
	
	var conn:Connection;
	
	public function new(conn) {
		this.conn = conn;
	}
	
	var count:Int;
	var errors:Array<Error>;
	var done:FutureTrigger<Outcome<Noise, Array<Error>>>;
	
	function retain()
		count++;
		
	function release()
		if(--count == 0)
			done.trigger(errors.length == 0 ? Success(Noise) : Failure(errors));
	
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
			case Success(ret):
				try {
					compare(ret, v);
					Success(Noise); 
				} catch(err:String) {
					trace('Expected $v, got $ret');
					Failure(new Error(err, pos));
				}
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
				try compare(errName, err.getName()) catch(e:Dynamic) {
					trace(err.getParameters()[0]);
					throw e;
				}
				compare(message, (err.getParameters()[0]:String).split('\n')[0]);
				Success(Noise);
			} catch(err:String) Failure(new Error(err, pos));
		});
		
		handle(f);
	}
	
	public function run() {
		count = 0;
		errors = [];
		done = Future.trigger();
		test();
		return done.asFuture();
	}
	
	function test() {
		
	}
}