package rethinkdb.reql.util;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

abstract ObjectOrFunction(Term) from TermBase from Term to Term to Expr {
	@:from
	public static inline function ofFunc(f:Expr->Expr):ObjectOrFunction
		return Expr.ofFunc1(f).toTerm();
	@:from
	public static inline function ofObject(v:{}):ObjectOrFunction
		return TDatum(Datum.fromDynamic(v));
}