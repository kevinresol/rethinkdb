package rethinkdb.response;

import tink.protocol.rethinkdb.Term;

enum ReqlError {
	ReqlDriverCompileError(message:String, term:Term, backtrace:Backtrace);
	ReqlServerCompileError(message:String, term:Term, backtrace:Backtrace);
	ReqlDriverError(message:String, term:Term, backtrace:Backtrace);
	ReqlAuthError(message:String, term:Term, backtrace:Backtrace);
	ReqlRuntimeError(message:String, term:Term, backtrace:Backtrace);
	
	ReqlTimeoutError(message:String, term:Term, backtrace:Backtrace);
	ReqlAvailabilityError(message:String, term:Term, backtrace:Backtrace);
	
	// from server:
	ReqlInternalError(message:String, term:Term, backtrace:Backtrace);
	ReqlResourceLimitError(message:String, term:Term, backtrace:Backtrace);
	ReqlQueryLogicError(message:String, term:Term, backtrace:Backtrace);
	ReqlNonExistenceError(message:String, term:Term, backtrace:Backtrace);
	ReqlOpFailedError(message:String, term:Term, backtrace:Backtrace);
	ReqlOpIndeterminateError(message:String, term:Term, backtrace:Backtrace);
	ReqlUserError(message:String, term:Term, backtrace:Backtrace);
	ReqlPermissionError(message:String, term:Term, backtrace:Backtrace);
}