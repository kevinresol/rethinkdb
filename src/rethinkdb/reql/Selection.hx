package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;

@:forward
abstract Selection(Expr) from Term to Term to Expr {
	
	// Writing data
	public inline function update(v:ObjectOrFunction):Expr
		return TUpdate([this, v]);
	public inline function replace(v:ObjectOrFunction):Expr
		return TReplace([this, v]);
	public inline function delete():Expr
		return TDelete(this);
		
	public inline function filter(f:Expr->Expr):Selection
		return TFilter([this, (f:Expr)]);
}