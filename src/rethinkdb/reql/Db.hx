package rethinkdb.reql;

import rethinkdb.Connection;
import tink.protocol.rethinkdb.Term;

// @:forward
abstract Db(Expr) from Expr to Expr {
	public inline function run(conn:Connection)
		return this.run(conn);
	public inline function tableCreate(name:String):Expr
		return TTableCreate(name);
	public inline function tableDrop(name:String):Expr
		return TTableDrop(name);
	public inline function tableList():Expr
		return TTableDrop([]);
	public inline function table(name:String):Table
		return TTable([this, TDatum(name)]);
		
	// Administration
	public inline function grant(v:Expr, opt:Expr):Expr
		return TGrant([this, v, opt]);
	public inline function config():Expr
		return TConfig(this);
	public inline function rebalance():Expr
		return TRebalance(this);
	public inline function reconfigure(v:Expr):Expr
		return TReconfigure([this, v]);
	public inline function wait(?opt:Expr):Expr
		return TWait({
			var args = [this];
			if(opt != null) args.push(opt);
			args;
		});
}