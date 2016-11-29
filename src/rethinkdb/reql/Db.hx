package rethinkdb.reql;

import rethinkdb.Connection;
import tink.protocol.rethinkdb.Term;

// @:forward
abstract Db(Expr) from Expr to Expr {
	public inline function run(conn:Connection)
		return this.run(conn);
	public inline function tableCreate(name:Expr, ?opt:{?primary_key:String, ?durability:String, ?shards:Int, ?replicas:Int, ?primary_replica_tag:String}):Expr
		return TTableCreate([this, name], opt);
	public inline function tableDrop(name:Expr):Expr
		return TTableDrop([this, name]);
	public inline function tableList():Expr
		return TTableList([this]);
	public inline function table(name:Expr):Table
		return TTable([this, name]);
		
	// Administration
	public inline function grant(v:Expr, opt:Expr):Expr
		return TGrant([this, v, opt]);
	public inline function config():Expr
		return TConfig([this]);
	public inline function rebalance():Expr
		return TRebalance([this]);
	public inline function reconfigure(v:Expr):Expr
		return TReconfigure([this, v]);
	public inline function wait(?opt:Expr):Expr
		return TWait({
			var args = [this];
			if(opt != null) args.push(opt);
			args;
		});
}