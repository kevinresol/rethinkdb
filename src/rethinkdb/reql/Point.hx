package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Point(Geometry) from Term to Term to Geometry {
	
}