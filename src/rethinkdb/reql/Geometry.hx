package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Geometry(Term) from Term to Term {
	
	public inline function distance(v:Geometry):Number
		return TDistance([this, v]);
	public inline function toGeojson():Dynamic
		return TToGeojson([this]);
	public inline function includes(v:Geometry):Boolean
		return TIncludes([this, v]);
	public inline function intersects(v:Geometry):Boolean
		return TIntersects([this, v]);
}