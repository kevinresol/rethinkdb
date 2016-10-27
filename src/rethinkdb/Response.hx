package rethinkdb;

import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Response as ProtocolResponse;
using tink.CoreApi;

class ResponseTools {
	public static function asCursor(s:Surprise<Response, Error>)
		return s >> function(r:Response) return r.asCursor();
	public static function asAtom(s:Surprise<Response, Error>)
		return s >> function(r:Response) return r.asAtom();
}

class Response {
	public var response:ProtocolResponse;
	public var connection:Connection;
	public var query:Query;
	
	public function new(response, connection, query) {
		this.response = response;
		this.connection = connection;
		this.query = query;
	}
	
	public function asCursor<T>():Outcome<Cursor<T>, Error>
		return switch this.response.type {
			case SUCCESS_SEQUENCE | SUCCESS_PARTIAL: Success(new Cursor(response, connection, query));
			case CLIENT_ERROR: Failure(Error.withData('Client Error: ' + response.response[0], response.response[0]));
			case COMPILE_ERROR: Failure(Error.withData('Compile Error: ' + response.response[0], response.response[0]));
			case RUNTIME_ERROR: Failure(Error.withData('Runtime Error: ' + response.response[0], response.response[0]));
			case SUCCESS_ATOM | WAIT_COMPLETE | SERVER_INFO: Failure(new Error('Invalid cast'));
		}
		
	public function asAtom<T>():Outcome<T, Error>
		return switch this.response.type {
			case SUCCESS_ATOM | SERVER_INFO: Success(response.response[0]); 
			case CLIENT_ERROR: Failure(Error.withData('Client Error: ' + response.response[0], response.response[0]));
			case COMPILE_ERROR: Failure(Error.withData('Compile Error: ' + response.response[0], response.response[0]));
			case RUNTIME_ERROR: Failure(Error.withData('Runtime Error: ' + response.response[0], response.response[0]));
			case SUCCESS_SEQUENCE | SUCCESS_PARTIAL | WAIT_COMPLETE: Failure(new Error('Invalid cast'));
		}
}