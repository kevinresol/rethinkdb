package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestObject extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom({  }, r.expr({  }));
			@:await assertAtom({ "a" : 1 }, r.expr({ "a" : 1 }));
			@:await assertAtom({ "a" : 1 }, r.expr({ "a" : r.expr(1) }));
			@:await assertAtom({ "a" : { "b" : [{ "c" : 2 }, "a", 4] } }, r.expr({ "a" : { "b" : [{ "c" : 2 }, "a", 4] } }));
			@:await assertAtom("OBJECT", r.expr({ "a" : 1 }).typeOf());
			@:await assertAtom("{\"a\":1}", r.expr({ "a" : 1 }).coerceTo("string"));
			@:await assertAtom({ "a" : 1 }, r.expr({ "a" : 1 }).coerceTo("object"));
			@:await assertAtom([["a", 1]], r.expr({ "a" : 1 }).coerceTo("array"));
			@:await assertError("ReqlCompileError", "Second argument to `r.expr` must be a number.", r.expr({  }, "foo"));
			@:await assertAtom({  }, r.object());
			@:await assertAtom({ "a" : 1, "b" : 2 }, r.object("a", 1, "b", 2));
			@:await assertAtom(3, r.object("c" + "d", 3));
			@:await assertError("ReqlQueryLogicError", "OBJECT expects an even number of arguments (but found 3).", r.object("o", "d", "d"));
			@:await assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", r.object(1, 1));
			@:await assertError("ReqlQueryLogicError", "Duplicate key \"e\" in object.  (got 4 and 5 as values)", r.object("e", 4, "e", 5));
			@:await assertError("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", r.object("g", r.db("test")));
		};
		return Noise;
	}
}