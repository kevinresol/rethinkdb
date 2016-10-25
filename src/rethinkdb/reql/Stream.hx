package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Stream(Expr) from Term to Term to Expr {
	
	// Selecting data
	public inline function filter(f:Expr->Expr):Stream
		return TFilter([this, (f:Expr)]);
		
	// Joins
	public inline function zip():Stream
		return TZip(this);
		
}