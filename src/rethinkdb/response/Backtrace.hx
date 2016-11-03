package rethinkdb.response;

@:forward
abstract Backtrace(Array<Frame>) from Array<Frame> {
	public static function parse(v:Array<Dynamic>):Backtrace {
		return [for(i in v) Std.is(i, String) ? Opt(i) : Pos(i)];
	}
}

enum Frame {
	Pos(v:Int);
	Opt(v:String);
}