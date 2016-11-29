package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestObject extends TestBase {
	@:async
	override function test() {
		@:await assertAtom({  }, r.expr({  }));
		@:await assertAtom({ "a" : 1 }, r.expr({ "a" : 1 }));
		@:await assertAtom({ "a" : 1, "b" : "two", "c" : true }, r.expr({ "a" : 1, "b" : "two", "c" : true }));
		@:await assertAtom({ "a" : 1 }, r.expr({ "a" : r.expr(1) }));
		@:await assertAtom({ "a" : { "b" : ([{ "c" : 2 }, "a", 4] : Array<Dynamic>) } }, r.expr({ "a" : { "b" : ([{ "c" : 2 }, "a", 4] : Array<Dynamic>) } }));
		@:await assertAtom("OBJECT", r.expr({ "a" : 1 }).typeOf());
		@:await assertAtom("{\"a\":1}", r.expr({ "a" : 1 }).coerceTo("string"));
		@:await assertAtom({ "a" : 1 }, r.expr({ "a" : 1 }).coerceTo("object"));
		@:await assertAtom(([(["a", 1] : Array<Dynamic>)] : Array<Dynamic>), r.expr({ "a" : 1 }).coerceTo("array"));
		@:await assertAtom({  }, r.object());
		@:await assertAtom({ "a" : 1, "b" : 2 }, r.object("a", 1, "b", 2));
		@:await assertAtom({ "cd" : 3 }, r.object("c" + "d", 3));
		@:await assertError(err("ReqlQueryLogicError", "OBJECT expects an even number of arguments (but found 3).", ([] : Array<Dynamic>)), r.object("o", "d", "d"));
		@:await assertError(err("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", ([] : Array<Dynamic>)), r.object(1, 1));
		@:await assertError(err("ReqlQueryLogicError", "Duplicate key \"e\" in object.  (got 4 and 5 as values)", ([] : Array<Dynamic>)), r.object("e", 4, "e", 5));
		@:await assertError(err("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", ([] : Array<Dynamic>)), r.object("g", r.db("test")));
		return Noise;
	}
}