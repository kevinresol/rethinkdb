package rethinkdb.response;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Backtrace(Array<Frame>) from Array<Frame> {
	public static function parse(v:Array<Dynamic>):Backtrace {
		return [for(i in v) Std.is(i, String) ? Opt(i) : Pos(i)];
	}
	
	public function resolve(v:Term):String {
		throw "Not implmented";
	}
}

enum Frame {
	Pos(v:Int);
	Opt(v:String);
}