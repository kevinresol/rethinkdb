package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;

// @:forward
abstract ArrayExpr(Sequence) from Term to Term {
	
	// Selecting data
	public inline function filter(f:Expr->Expr):ArrayExpr
		return TFilter([(this:Expr), (f:Expr)]);
		
	// Joins
	public inline function innerJoin(v:Sequence, f:Expr->Expr->Expr):ArrayExpr
		return TInnerJoin([(this:Expr), (v:Expr), (f:Expr)]);
	public inline function outerJoin(v:Sequence, f:Expr->Expr->Expr):ArrayExpr
		return TOuterJoin([(this:Expr), (v:Expr), (f:Expr)]);
	public inline function zip():ArrayExpr
		return TZip(this);
		
	// Transformation
	public inline function map(f:Expr->Expr):ArrayExpr
		return TMap([(this:Expr), (f:Expr)]);
}