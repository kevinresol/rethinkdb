package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestPoint extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom([{ "new_val" : null }], fetch(basic, 1));
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), tbl.insert({ "id" : 1 }));
		@:await assertAtom([{ "old_val" : null, "new_val" : { "id" : 1 } }], fetch(basic, 1));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), tbl.get(1).update({ "update" : 1 }));
		@:await assertAtom([{ "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "update" : 1 } }], fetch(basic, 1));
		@:await assertAtom(partial({ "errors" : 0, "deleted" : 1 }), tbl.get(1).delete());
		@:await assertAtom([{ "old_val" : { "id" : 1, "update" : 1 }, "new_val" : null }], fetch(basic, 1));
		@:await assertAtom([4, 7], fetch(filter, 2));
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), tbl.insert({ "id" : 3, "red" : 1, "green" : 1 }));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), tbl.get(3).update({ "blue" : 2, "green" : 3 }));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), tbl.get(3).update({ "green" : 4 }));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), tbl.get(3).update({ "blue" : 4 }));
		@:await assertAtom([{ "red" : 1 }, { "blue" : 2, "red" : 1 }, { "blue" : 2, "red" : 1 }, { "blue" : 4, "red" : 1 }], fetch(pluck, 4));
		var dtbl = r.db("rethinkdb").table("_debug_scratch");
		@:await assertAtom([{ "new_val" : null }], fetch(debug, 1));
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), dtbl.insert({ "id" : 1 }));
		@:await assertAtom([{ "old_val" : null, "new_val" : { "id" : 1 } }], fetch(debug, 1));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), dtbl.get(1).update({ "update" : 1 }));
		@:await assertAtom([{ "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "update" : 1 } }], fetch(debug, 1));
		@:await assertAtom(partial({ "errors" : 0, "deleted" : 1 }), dtbl.get(1).delete());
		@:await assertAtom([{ "old_val" : { "id" : 1, "update" : 1 }, "new_val" : null }], fetch(debug, 1));
		@:await assertAtom({ "skipped" : 0, "deleted" : 0, "unchanged" : 0, "errors" : 0, "replaced" : 0, "inserted" : 1 }, dtbl.insert({ "id" : 5, "red" : 1, "green" : 1 }));
		@:await assertAtom([{ "red" : 1 }], fetch(dtblPluck, 1));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), dtbl.get(5).update({ "blue" : 2, "green" : 3 }));
		@:await assertAtom([{ "blue" : 2, "red" : 1 }], fetch(dtblPluck, 1));
		@:await assertAtom(partial([{ "new_val" : partial({ "db" : "test" }) }]), fetch(rtblPluck, 1));
		@:await assertAtom(partial([{ "old_val" : partial({ "db" : "test" }), "new_val" : partial({ "db" : "test" }) }]), fetch(rtblPluck, 1, 2));
		@:await dropTables(_tables);
		return Noise;
	}
}