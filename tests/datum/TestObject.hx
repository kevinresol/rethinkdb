package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestObject extends TestBase {
	override function test() {
		assertAtom({  }, r.expr({  }));
		assertAtom([[a, 1]], r.expr({ a : 1 }).coerceTo("array"));
		assertAtom({  }, r.object());
		assertError("ReqlQueryLogicError", "OBJECT expects an even number of arguments (but found 3).", r.object("o", "d", "d"));
		assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", r.object(1, 1));
		assertError("ReqlQueryLogicError", "Duplicate key \"e\" in object.  (got 4 and 5 as values)", r.object("e", 4, "e", 5));
		assertError("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", r.object("g", r.db("test")));
	}
}