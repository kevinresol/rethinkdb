package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract OrderBy(Expr) from Expr to Expr {
	public inline function new(o:OrderByOptions) this = TOrderBy(o);
	public inline function get(id:String):Expr return TGet([this, TDatum(id)]);
}
