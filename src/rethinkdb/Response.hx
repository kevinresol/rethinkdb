package rethinkdb;

import rethinkdb.reql.ReqlError;
import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Response as ProtocolResponse;
using tink.CoreApi;

class ResponseTools {
	public static function asCursor<T>(s:Surprise<Response, Error>):Surprise<Cursor<T>, ReqlError>
		return s.map(function(o) return switch o {
			case Success(r): r.asCursor();
			case Failure(f): Failure(ReqlDriverError(f.toString()));
		});
	public static function asAtom<T>(s:Surprise<Response, Error>):Surprise<Atom<T>, ReqlError>
		return s.map(function(o) return switch o {
			case Success(r): r.asAtom();
			case Failure(f): Failure(ReqlDriverError(f.toString()));
		});
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
	
	public function asCursor<T>():Outcome<Cursor<T>, ReqlError>
		return switch this.response.type {
			case SUCCESS_SEQUENCE | SUCCESS_PARTIAL: Success(new Cursor(response, connection, query));
			case CLIENT_ERROR: Failure(ReqlDriverError(response.response[0]));
			case COMPILE_ERROR: Failure(ReqlServerCompileError(response.response[0]));
			case RUNTIME_ERROR: Failure((response:ReqlError));
			case SUCCESS_ATOM | WAIT_COMPLETE | SERVER_INFO: Failure(ReqlDriverError('Invalid cast'));
		}
		
	public function asAtom<T>():Outcome<Atom<T>, ReqlError>
		return switch this.response.type {
			case SUCCESS_ATOM | SERVER_INFO: Success(response.response[0]); 
			case CLIENT_ERROR: Failure(ReqlDriverError(response.response[0]));
			case COMPILE_ERROR: Failure(ReqlServerCompileError(response.response[0]));
			case RUNTIME_ERROR: Failure((response:ReqlError));
			case SUCCESS_SEQUENCE | SUCCESS_PARTIAL | WAIT_COMPLETE: Failure(ReqlDriverError('Invalid cast'));
		}
}