package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Db(Expr) from Expr to Expr {
	public inline function tableCreate(name:String):Expr
		return TTableCreate(name);
	public inline function tableDrop(name:String):Expr
		return TTableDrop(name);
	public inline function tableList():ArrayExpr
		return TTableDrop([]);
	public inline function table(name:String):Table
		return TTable([this, TDatum(name)]);
}