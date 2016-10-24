package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;

@:forward
abstract Sequence(Expr) from Expr to Expr to Term {
	
	// Joins
	public inline function innerJoin(v:Sequence, f:Expr->Expr->Expr):Stream
		return TInnerJoin([this, v, (f:Expr)]);
	public inline function outerJoin(v:Sequence, f:Expr->Expr->Expr):Stream
		return TOuterJoin([this, v, (f:Expr)]);
	public inline function eqJoin(v:Expr, table:Table):Stream
		return TEqJoin([this, v, table]);
		
	// Transformation
	public inline function map(f:Expr->Expr):Stream
		return TMap([this, (f:Expr)]);
		
	// Geospatial commands
	public inline function includes(v:Geometry):Sequence
		return TIncludes([this, v]);
	public inline function intersects(v:Geometry):Sequence
		return TIntersects([this, v]);
	
}