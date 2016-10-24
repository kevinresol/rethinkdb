package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;

@:forward
abstract ArrayExpr(Expr) from Expr to Expr to Term {
	
	// Selecting data
	public inline function filter(f:Expr->Expr):ArrayExpr
		return TFilter([this, (f:Expr)]);
		
	// Joins
	public inline function innerJoin(v:Sequence, f:Expr->Expr->Expr):ArrayExpr
		return TInnerJoin([this, v, (f:Expr)]);
	public inline function outerJoin(v:Sequence, f:Expr->Expr->Expr):ArrayExpr
		return TOuterJoin([this, v, (f:Expr)]);
	public inline function zip():ArrayExpr
		return TZip(this);
		
	// Transformation
	public inline function map(f:Expr->Expr):ArrayExpr
		return TMap([this, (f:Expr)]);
}