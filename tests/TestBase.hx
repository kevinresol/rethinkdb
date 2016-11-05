package;

import deepequal.DeepEqual;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.response.*;

using rethinkdb.response.Response;
using tink.CoreApi;

@:await
class TestBase {
	
	var conn:Connection;
	
	public static var customChecks = [
		{
			cond: function(e, a) return Std.is(e, ArrLen),
			check: function(e, a) cast(e, ArrLen).check(a),
		},
		{
			cond: function(e, a) return Std.is(e, Uuid),
			check: function(e, a) cast(e, Uuid).check(a),
		},
	];
	
	public function new(conn) {
		this.conn = conn;
	}
	
	public static function compare(e:Dynamic, a:Dynamic, ?pos:haxe.PosInfos) {
		return DeepEqual.compare(e, a, customChecks);
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
			return Success(Noise);
		});
	}
	
	function assertAtom<T>(v:T, e:Expr, ?pos:haxe.PosInfos) {
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
		
		return handle(f);
	}
	
	function assertBag(v:Array<Dynamic>, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asCursor().flatMap(function(o) return switch o {
			case Success(cur):
				cur.toArray().map(function(arr) return try {
					compare(v, arr);
					Success(Noise); 
				} catch(err:String) {
					trace('Expected $v, got $arr');
					Failure(new Error(err, pos));
				});
			case Failure(f): Future.sync(Failure(new Error('Unexpected error $f', pos)));
		});
		
		return handle(f);
	}
	
	function assertPartial(v:{}, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(ret):
				try {
					if(!Reflect.isObject(ret)) throw 'Expected object, got $ret';
					for(field in Reflect.fields(v)) {
						if(!Reflect.hasField(ret, field)) throw 'Does not contain field $field';
						compare(Reflect.field(v, field), Reflect.field(ret, field));
					}
					Success(Noise); 
				} catch(err:String) {
					trace('Expected $v, got $ret');
					Failure(new Error(err, pos));
				}
			case Failure(f): Failure(new Error('Unexpected error $f', pos));
		});
		
		return handle(f);
	}
	
	function assertError(errName:String, message:String, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(_): Failure(new Error("Unexpected failure", pos));
			case Failure(f): try {
				var err:ReqlError = f.data;
				try compare(errName, err.getName()) catch(e:Dynamic) {
					trace('Expected $errName, got ' +  err.getName() + ' - ' + err.getParameters()[0]);
					throw e;
				}
				compare(message, (err.getParameters()[0]:String).split('\n')[0]);
				Success(Noise);
			} catch(err:String) Failure(new Error(err, pos));
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
	
	inline function xrange(s:Int, ?e:Int) {
		return e == null ? 0...s : s...e;
	}
	function arrlen(len:Int, other:Dynamic) {
		return new ArrLen(len, other);
	}
	function uuid<T>() {
		return new Uuid();
	}
	
	public function run() {
		total = 0;
		errors = [];
		return test().map(function(_) return new Pair(total, errors));
	}
	
	@:async function test() {
		return Noise;
	}
}

class Uuid {
	public function new() {
		
	}
	
	public function check(other:Dynamic) {
		return Std.is(other, String); // TODO
	}
}

class ArrLen {
	
	var length:Int;
	var item:Dynamic;
	
	public function new(length:Int, item:Dynamic) {
		this.length = length;
		this.item = item;
	}
	
	public function check(other:Dynamic) {
		if(!Std.is(other, Array)) throw 'Not array';
		var other:Array<Dynamic> = cast other;
		if(other.length != length) throw 'Not of the expected length';
		if(item == null) return;
		for(i in other) TestBase.compare(item, i);
	}
}