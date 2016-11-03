package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

@:forward
abstract Table(Expr) from Term to Term to Expr {
	
	public inline function indexCreate(name:Expr):Expr
		return TIndexCreate([name]);
	public inline function indexDrop(name:Expr):Expr
		return TIndexDrop([name]);
	public inline function indexList():Expr
		return TIndexDrop([]);
	public inline function indexRename(oldName:Expr, newName:Expr):Expr
		return TIndexRename([oldName, newName]);
	public inline function indexStatus():Expr
		return TIndexStatus([]);
	public inline function indexWait():Expr
		return TIndexWait([]);
	
	// Writing data
	public inline function insert(v:Expr):Expr
		return TInsert([this, v]);
	public inline function update(v:Expr):Expr
		return TUpdate([this, v]);
	public inline function replace(v:Expr):Expr
		return TReplace([this, v]);
	public inline function delete():Expr
		return TDelete([this]);
	public inline function sync():Expr
		return TSync([this]);
	
	public inline function get(id:Expr):Expr
		return TGet([this, id]);
	public inline function getAll(v1:Expr, ?v2:Expr, ?v3:Expr, ?v4:Expr, ?v5:Expr):Expr
		return TGetAll({
			var args = [this, v1];
			if(v2 != null) args.push(v2);
			if(v3 != null) args.push(v3);
			if(v4 != null) args.push(v4);
			if(v5 != null) args.push(v5);
			args;
		});
	public inline function between(lower:Expr, upper:Expr):Expr
		return TBetween([this, lower, upper]);
		
	public inline function getIntersecting(v:Expr):Expr
		return TGetIntersecting([this, v]);
	public inline function getNearest(v:Expr):Expr
		return TGetNearest([this, v]);
		
	// Administration
	public inline function grant(v:Expr, opt:Expr):Expr
		return TGrant([this, v, opt]);
	public inline function config():Expr
		return TConfig([this]);
	public inline function rebalance():Expr
		return TRebalance([this]);
	public inline function reconfigure(v:Expr):Expr
		return TReconfigure([this, v]);
	public inline function status():Expr
		return TStatus([this]);
	public inline function wait(?opt:Expr):Expr
		return TWait({
			var args = [this];
			if(opt != null) args.push(opt);
			args;
		});
	
}

abstract InsertExpr(Expr) from Expr to Expr {
	@:from
	public static inline function fromArray(v:Array<Dynamic>):InsertExpr
		return TMakeArray([for(i in v) TDatum(DatumTools.ofAny(i))]);
	
	@:from
	public static inline function fromObject(v:{}):InsertExpr
		return TDatum(DatumTools.ofAny(v));
}