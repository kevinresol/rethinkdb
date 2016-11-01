package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Frame;
import tink.protocol.rethinkdb.Response;

@:forward
abstract ReqlError(ReqlErrorType) from ReqlErrorType to ReqlErrorType {
	@:from
	public static function fromResponse(r:Response):ReqlError {
		return switch r.errorType {
			case INTERNAL: ReqlInternalError(r.response[0]);
			case RESOURCE_LIMIT: ReqlResourceLimitError(r.response[0]);
			case QUERY_LOGIC: ReqlQueryLogicError(r.response[0]);
			case NON_EXISTENCE: ReqlNonExistenceError(r.response[0]);
			case OP_FAILED: ReqlOpFailedError(r.response[0]);
			case OP_INDETERMINATE: ReqlOpIndeterminateError(r.response[0]);
			case USER: ReqlUserError(r.response[0]);
			case PERMISSION_ERROR: ReqlPermissionError(r.response[0]);
		}
	}
}

enum ReqlErrorType {
	ReqlDriverCompileError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlServerCompileError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlDriverError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlAuthError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlRuntimeError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlQueryLogicError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlNonExistenceError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlResourceLimitError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlUserError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlInternalError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlTimeoutError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlAvailabilityError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlOpFailedError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlOpIndeterminateError(message:String, ?term:Term, ?frames:Array<Frame>);
	ReqlPermissionError(message:String, ?term:Term, ?frames:Array<Frame>);
}