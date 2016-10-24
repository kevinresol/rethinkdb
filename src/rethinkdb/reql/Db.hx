package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Db(Expr) from Expr to Expr {
	
	public inline function table(name:String):Table return TTable([this, TDatum(name)]);
}