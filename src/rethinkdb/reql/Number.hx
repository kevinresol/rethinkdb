package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Number(Expr) from Expr to Expr to Term {
	
}