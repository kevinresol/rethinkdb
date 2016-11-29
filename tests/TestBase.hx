package;

import deepequal.DeepEqual;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.response.*;
import deepequal.DeepEqual.compare;
import deepequal.custom.*;

using rethinkdb.response.Response;
using tink.CoreApi;

@:await
class TestBase {
	
	var conn:Connection;
	
	public function new(conn) {
		this.conn = conn;
	}
	
	var total:Int;
	var errors:Array<Error>;
	
	function handle(s:Surprise<Noise, Error>)  {
		total++;
		return s.map(function(o) {
			switch o {
				case Success(_):
				case Failure(f): errors.push(f);
			}
			return Noise;
		});
	}
	
	function assertAtom<T>(v:T, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(ret): compare(v, ret);
			case Failure(f): Failure(new Error('Unexpected error $f', pos));
		});
		
		return handle(f);
	}
	
	function assertError<T>(v:T, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(_): Failure(new Error("Unexpected failure", pos));
			case Failure(f): compare(v, f.data);
		});
		
		return handle(f);
	}
	
	function createTables(names:Array<String>) {
		return Future.ofMany([for(name in names) r.db('test').tableCreate(name).run(conn)]) >>
			function(_) return Noise;
	}
	
	function dropTables(names:Array<String>) {
		return Future.ofMany([for(name in names) r.db('test').tableDrop(name).run(conn)]) >>
			function(_) return Noise;
	}
	
	
	inline function str(v:Dynamic)
		return Std.string(v);
	
	inline function range(s:Int, ?e:Int)
		return e == null ? 0...s : s...e;
		
	inline function xrange(s:Int, ?e:Int)
		return e == null ? 0...s : s...e;
	
	function arrlen(len:Int, other:Dynamic)
		return [for(i in 0...len) other];
	
	function uuid()
		return new Uuid();
	
	function bag(items:Array<Dynamic>)
		return new ArrayContains(items);
	
	function partial(obj:{})
		return new ObjectContains(obj);
	
	function err(name:String, message:String, ?f:Array<Dynamic>)
		return new EnumByName(ReqlError, name, [new StringStartsWith(message), new Anything(), new Anything()]);
	
	function err_regex(name:String, pattern:String, ?f:Array<Dynamic>)
		return new EnumByName(ReqlError, name, [new Regex(new EReg(pattern, '')), new Anything(), new Anything()]);
	
	function int_cmp(v:Int)
		return v;
	
	function float_cmp(v:Float)
		return v;
	
	
	@:async public function run() {
		total = 0;
		errors = [];
		@:await test();
		return new Pair(total, errors);
	}
	
	@:async function test() {
		return Noise;
	}
}

class Uuid implements deepequal.CustomCompare {
	public function new() {}
	
	public function check(other:Dynamic, compare) {
		return Std.is(other, String) ? // TODO
			Success(Noise) : 
			Failure(new Error('Expected UUID but got $other'));
	}
}
