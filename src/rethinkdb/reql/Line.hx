package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Line(Geometry) from Term to Term to Geometry {
	
	public inline function fill():Line
		return TFill(this);
}