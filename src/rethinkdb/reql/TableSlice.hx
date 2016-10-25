package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

@:forward
abstract TableSlice(Term) from Term to Term {
	
	
	public inline function between(lower:Expr, upper:Expr):TableSlice
		return TBetween([this, lower, upper]);
}