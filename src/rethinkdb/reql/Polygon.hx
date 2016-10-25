package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Polygon(Geometry) from Term to Term to Geometry {
	
	public inline function polygonSub(v:Polygon):Polygon
		return TPolygonSub([this, v]);
}