package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

@:forward
abstract Table(Expr) from Term to Term to Expr {
	
	public inline function indexCreate(name:String):Expr
		return TIndexCreate(name);
	public inline function indexDrop(name:String):Expr
		return TIndexDrop(name);
	public inline function indexList():ArrayExpr
		return TIndexDrop([]);
	public inline function indexRename(oldName:String, newName:String):Expr
		return TIndexRename([oldName, newName]);
	public inline function indexStatus():ArrayExpr
		return TIndexStatus([]);
	public inline function indexWait():ArrayExpr
		return TIndexWait([]);
	
	// Writing data
	public inline function insert(v:Array<Dynamic>):Expr
		return TInsert(this.concat([for(i in v) TDatum(Datum.fromDynamic(i))]));
	public inline function update(v:ObjectOrFunction):Expr
		return TUpdate([this, v]);
	public inline function replace(v:ObjectOrFunction):Expr
		return TReplace([this, v]);
	public inline function delete():Expr
		return TDelete(this);
	public inline function sync():Expr
		return TSync(this);
	
	public inline function get(id:String):SingleSelection
		return TGet([this, TDatum(id)]);
	public inline function getAll(ids:Array<String>):Selection
		return TGet(this.concat([for(id in ids) TDatum(id)]));
	public inline function between(lower:Expr, upper:Expr):TableSlice
		return TBetween([this, lower, upper]);
		
	public inline function getIntersecting(v:Expr):Expr
		return TGetIntersecting([this, v]);
	public inline function getNearest(v:Expr):Expr
		return TGetNearest([this, v]);
}