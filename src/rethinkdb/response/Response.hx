package rethinkdb.response;

import haxe.Json;
import haxe.Int64;
import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Response as RawResponse;
import tink.protocol.rethinkdb.Response.ResponseType;
import tink.protocol.rethinkdb.Response.ResponseNote;
import tink.protocol.rethinkdb.Response.ErrorType;
import rethinkdb.response.ReqlError;
using tink.CoreApi;

class ResponseTools {
	public static function asCursor<T>(s:Surprise<Response, Error>):Surprise<Cursor<T>, Error>
		return s.map(function(o) return switch o {
			case Success(r): r.asCursor();
			case Failure(f): Failure(f);
		});
	public static function asAtom<T>(s:Surprise<Response, Error>):Surprise<Atom<T>, Error>
		return s.map(function(o) return switch o {
			case Success(r): r.asAtom();
			case Failure(f): Failure(f);
		});
}

class Response {
	public var connection:Connection;
	public var query:Query;
	
	public var token:Int64;
	public var type:ResponseType;
	public var response:Array<Dynamic>;
	public var profile:Dynamic;
	public var notes:Array<ResponseNote>;
	
	public function new(connection, query, type, response, profile, notes) {
		this.connection = connection;
		this.query = query;
		this.token = query.token;
		
		this.type = type; 
		this.response = response;
		this.profile = profile;
		this.notes = notes;
	}
	
	public static function parse(response:RawResponse, connection, query:Query):Outcome<Response, Error> {
		var res = Json.parse(response.json);
		var type:ResponseType = res.t;
		
		inline function fail(ctor:String->Term->Backtrace->ReqlError, ?pos:haxe.PosInfos) {
			trace(query.toString());
			var err = ctor(res.r[0], query.term, Backtrace.parse(res.b));
			return Failure(Error.withData(err.getName() + ': ' + res.r[0], err, pos));
		}
		
		return switch type {
			case CLIENT_ERROR: fail(ReqlDriverError);
			case COMPILE_ERROR: fail(ReqlServerCompileError);
			case RUNTIME_ERROR: fail(switch (res.e:ErrorType) {
				case INTERNAL: ReqlInternalError;
				case RESOURCE_LIMIT: ReqlResourceLimitError;
				case QUERY_LOGIC: ReqlQueryLogicError;
				case NON_EXISTENCE: ReqlNonExistenceError;
				case OP_FAILED: ReqlOpFailedError;
				case OP_INDETERMINATE: ReqlOpIndeterminateError;
				case USER: ReqlUserError;
				case PERMISSION_ERROR: ReqlPermissionError;
			});
			default: Success(new Response(connection, query, type, res.r, res.p, res.n));
		}
	}
	
	public function isFeed() {
		if(notes == null) return false;
		for(n in notes) switch n {
			case SEQUENCE_FEED | ATOM_FEED | ORDER_BY_LIMIT_FEED | UNIONED_FEED: return true; 
			default:
		}
		return false;
	}
	
	public function asCursor<T>():Outcome<Cursor<T>, Error>
		return switch type {
			case SUCCESS_SEQUENCE | SUCCESS_PARTIAL: Success(new Cursor(this, connection, query));
			case SUCCESS_ATOM if(Std.is(response[0], Array)): Success(new Cursor(this, connection, query));
			default: Failure(Error.withData('Cannot cast to Cursor', ReqlDriverError('Invalid cast', query.term, [])));
		}
		
	public function asAtom<T>():Outcome<Atom<T>, Error>
		return switch type {
			case SUCCESS_ATOM | SERVER_INFO: Success(response[0]); 
			default: trace(this); Failure(Error.withData('Cannot cast to Atom', ReqlDriverError('Invalid cast', query.term, [])));
		}
}
