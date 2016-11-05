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
		{
			cond: function(e, a) return Std.is(e, Bag),
			check: function(e, a) cast(e, Bag).check(a),
		},
		{
			cond: function(e, a) return Std.is(e, Partial),
			check: function(e, a) cast(e, Partial).check(a),
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
			return Noise;
		});
	}
	
	function assertAtom<T>(v:T, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(ret):
				try {
					compare(v, ret);
					Success(Noise); 
				} catch(err:String) {
					// trace('Expected $v, got $ret', '');
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
	
	function assertErrorRegex(errName:String, regex:String, e:Expr, ?pos:haxe.PosInfos) {
		var f = e.run(conn).asAtom().map(function(o) return switch o {
			case Success(_): Failure(new Error("Unexpected failure", pos));
			case Failure(f): try {
				var err:ReqlError = f.data;
				var message:String = err.getParameters()[0];
				try compare(errName, err.getName()) catch(e:Dynamic) {
					trace('Expected $errName, got ' +  err.getName() + ' - $message');
					throw e;
				}
				if(!new EReg(regex, '').match(message)) throw 'Expected regex $regex but got $message';	
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
	function uuid() {
		return new Uuid();
	}
	function bag(items:Array<Dynamic>) {
		return new Bag(items);
	}
	function partial(obj:Dynamic) {
		return new Partial(obj);
	}
	
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

class Bag {
	var items:Array<Dynamic>;
	public function new(items:Array<Dynamic>) {
		this.items = items;
	}
	
	public function check(other:Dynamic) {
		if(!Std.is(other, Array)) throw 'Not array';
		var other:Array<Dynamic> = cast other;
		if(other.length != items.length) throw 'Not of the expected length';
		if(items == null) return;
		for(i in items) {
			var matched = false;
			for(o in other) try {
				TestBase.compare(i, o);
				matched = true;
				break;
			} catch(e:Dynamic) {}
			if(!matched) throw '$i not found in bag';
		}
	}
}
class Partial {
	var obj:Dynamic;
	public function new(obj:Dynamic) {
		this.obj = obj;
	}
	
	public function check(other:Dynamic) {
		if(!Reflect.isObject(other)) throw 'Expected object, got $other';
		for(field in Reflect.fields(obj)) {
			if(!Reflect.hasField(other, field)) throw 'Does not contain field $field';
			TestBase.compare(Reflect.field(obj, field), Reflect.field(other, field));
		}
	}
}