package rethinkdb.reql.util;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

abstract ObjectOrFunction(Expr) from Expr to Expr {
	@:from
	public static inline function ofFunc(f:Expr->Expr):ObjectOrFunction
		return Expr.ofFunc1(f);
	@:from
	public static inline function ofObject(v:{}):ObjectOrFunction
		return TDatum(Datum.fromDynamic(v));
}