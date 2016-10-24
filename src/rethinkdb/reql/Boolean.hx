package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Boolean(Expr) from Expr to Expr to Term {
	
}