package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test1133 extends TestBase {
	@:async
	override function test() {
		var a = {  };
		var b = { "a" : a };
		a["b"] = b;
		@:await assertError(err("ReqlDriverCompileError", "Nesting depth limit exceeded.", []), r.expr(a));
		@:await assertError(err("ReqlDriverCompileError", "Nesting depth limit exceeded.", []), r.expr({ "a" : { "a" : { "a" : { "a" : { "a" : { "a" : { "a" : {  } } } } } } } }, 7));
		@:await assertAtom(({ "a" : { "a" : { "a" : { "a" : { "a" : { "a" : { "a" : {  } } } } } } } }), r.expr({ "a" : { "a" : { "a" : { "a" : { "a" : { "a" : { "a" : {  } } } } } } } }, 10));
		return Noise;
	}
}