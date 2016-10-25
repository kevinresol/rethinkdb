package rethinkdb;

import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Response as ProtocolResponse;

@:forward
abstract Response(Res) {
	public inline function new(response, connection, query)
		this = new Res(response, connection, query);
		
	@:to
	public inline function toCursor<T>():Cursor<T>
		return new Cursor(this.response, this.connection, this.query);
	
	public inline function asAtom<T>():T
		return this.response.response[0];
}

class Res {
	public var response:ProtocolResponse;
	public var connection:Connection;
	public var query:Query;
	
	public function new(response, connection, query) {
		this.response = response;
		this.connection = connection;
		this.query = query;
	}
}