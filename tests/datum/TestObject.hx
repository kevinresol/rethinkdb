package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestObject extends TestBase {
	override function test() {
		assertAtom({  }, r.expr({  }));
		assertAtom({ "a" : 1 }, r.expr({ "a" : 1 }));
		assertAtom({ "a" : 1 }, r.expr({ "a" : r.expr(1) }));
		assertAtom({ "a" : { "b" : [{ "c" : 2 }, "a", 4] } }, r.expr({ "a" : { "b" : [{ "c" : 2 }, "a", 4] } }));
		assertAtom("OBJECT", r.expr({ "a" : 1 }).typeOf());
		assertAtom("{\"a\":1}", r.expr({ "a" : 1 }).coerceTo("string"));
		assertAtom({ "a" : 1 }, r.expr({ "a" : 1 }).coerceTo("object"));
		assertAtom([["a", 1]], r.expr({ "a" : 1 }).coerceTo("array"));
		assertError("ReqlCompileError", "Second argument to `r.expr` must be a number.", r.expr({  }, "foo"));
		assertAtom({  }, r.object());
		assertAtom({ "a" : 1, "b" : 2 }, r.object("a", 1, "b", 2));
		assertAtom(3, r.object("c" + "d", 3));
		assertError("ReqlQueryLogicError", "OBJECT expects an even number of arguments (but found 3).", r.object("o", "d", "d"));
		assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", r.object(1, 1));
		assertError("ReqlQueryLogicError", "Duplicate key \"e\" in object.  (got 4 and 5 as values)", r.object("e", 4, "e", 5));
		assertError("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", r.object("g", r.db("test")));
	}
}