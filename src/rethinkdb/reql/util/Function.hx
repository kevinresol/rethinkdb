package rethinkdb.reql.util;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

abstract Function(Expr) from Expr to Expr {
	@:from
	public static inline function ofFunc1(f:Expr->Expr):Function
		return Expr.ofFunc1(f);
	@:from
	public static inline function ofFunc2(f:Expr->Expr->Expr):Function
		return Expr.ofFunc2(f);
	@:from
	public static inline function ofFunc13(f:Expr->Expr->Expr->Expr):Function
		return Expr.ofFunc3(f);
}