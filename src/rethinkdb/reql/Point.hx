package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Point(Geometry) from Expr to Expr to Term to Geometry {
	
}