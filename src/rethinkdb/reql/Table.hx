package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Table(Expr) from Expr to Expr {
	
	public inline function get(id:String):Expr return TGet([this, TDatum(id)]);
}