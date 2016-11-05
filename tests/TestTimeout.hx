package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestTimeout extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "JavaScript query `while(true) {}` timed out after 5.000 seconds.", r.js("while(true) {}"));
			@:await assertError("ReqlQueryLogicError", "JavaScript query `while(true) {}` timed out after 1.300 seconds.", r.js("while(true) {}", { "timeout" : 1.3 }));
			@:await assertError("ReqlQueryLogicError", "JavaScript query `while(true) {}` timed out after 8.000 seconds.", r.js("while(true) {}", { "timeout" : 8 }));
			@:await assertError("ReqlQueryLogicError", "JavaScript query `(function(x) { while(true) {} })` timed out after 5.000 seconds.", r.expr("foo").do_(r.js("(function(x) { while(true) {} })")));
			@:await assertError("ReqlQueryLogicError", "JavaScript query `(function(x) { while(true) {} })` timed out after 1.300 seconds.", r.expr("foo").do_(r.js("(function(x) { while(true) {} })", { "timeout" : 1.3 })));
			@:await assertError("ReqlQueryLogicError", "JavaScript query `(function(x) { while(true) {} })` timed out after 8.000 seconds.", r.expr("foo").do_(r.js("(function(x) { while(true) {} })", { "timeout" : 8 })));
			@:await assertError("ReqlNonExistenceError", "Error in HTTP GET of `httpbin.org/delay/10`:" + " timed out after 0.800 seconds.", r.http("httpbin.org/delay/10", { "timeout" : 0.8 }));
			@:await assertError("ReqlNonExistenceError", "Error in HTTP PUT of `httpbin.org/delay/10`:" + " timed out after 0.000 seconds.", r.http("httpbin.org/delay/10", { "method" : "PUT", "timeout" : 0.0 }));
		};
		return Noise;
	}
}