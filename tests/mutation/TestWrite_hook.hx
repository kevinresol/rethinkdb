package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestWrite_hook extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "created" : 1 }), tbl.setWriteHook(function(a, b, c) return c.merge({ "num" : 1 })));
		@:await assertAtom(partial({ "inserted" : 1, "errors" : 0 }), tbl.insert({ "id" : 1 }));
		@:await assertAtom([{ "id" : 1, "num" : 1 }], tbl);
		@:await assertAtom(partial({ "deleted" : 1 }), tbl.setWriteHook(null));
		@:await assertAtom(partial({ "created" : 1 }), tbl.setWriteHook(function(a, b, c) return c.merge({ "num" : 2 })));
		@:await assertAtom(partial({ "replaced" : 1 }), tbl.setWriteHook(function(a, b, c) return c.merge({ "num" : 2 })));
		@:await assertAtom(partial({ "replaced" : 1, "errors" : 0 }), tbl.update({ "blah" : 2 }));
		@:await assertAtom([{ "id" : 1, "blah" : 2, "num" : 2 }], tbl);
		@:await assertAtom(partial({ "deleted" : 1 }), tbl.setWriteHook(null));
		@:await assertError("ReqlQueryLogicError", "Write hook functions must expect 3 arguments.", tbl.setWriteHook(function(a) return 1));
		@:await assertError("ReqlQueryLogicError", "Could not prove function deterministic.  Write hook functions must be deterministic.", tbl.setWriteHook(function(a, b, c) return r.js(1)));
		@:await assertAtom(partial({ "created" : 1 }), tbl.setWriteHook(function(a, b, c) return null));
		@:await assertAtom(partial({ "first_error" : "A write hook function must not turn a replace/insert into a deletion." }), tbl.insert({  }));
		@:await assertAtom(partial({ "replaced" : 1 }), tbl.setWriteHook(function(a, b, c) return {  }));
		@:await assertAtom(partial({ "first_error" : "A write hook function must not turn a deletion into a replace/insert." }), tbl.delete());
		@:await assertAtom(partial({ "deleted" : 1 }), tbl.setWriteHook(null));
		@:await assertAtom(partial({ "created" : 1 }), tbl.setWriteHook(function(a, b, c) return r.error("OH NOES!")));
		@:await assertAtom(partial({ "first_error" : "Error in write hook: OH NOES!" }), tbl.insert({  }));
		@:await assertAtom(partial({ "first_error" : "Error in write hook: OH NOES!" }), tbl.delete());
		@:await dropTables(_tables);
		return Noise;
	}
}