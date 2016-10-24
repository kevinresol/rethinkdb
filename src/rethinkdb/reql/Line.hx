package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Line(Geometry) from Expr to Expr to Term to Geometry {
	
	public inline function fill():Line
		return TFill(this);
}