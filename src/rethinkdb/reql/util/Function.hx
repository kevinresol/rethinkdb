package rethinkdb.reql.util;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

abstract Function(Term) to Term {
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