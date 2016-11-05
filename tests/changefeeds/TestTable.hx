package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestTable extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 2 }), tbl.insert([{ "id" : 1 }, { "id" : 2 }]));
		@:await assertAtom(bag([{ "old_val" : null, "new_val" : { "id" : 1 } }, { "old_val" : null, "new_val" : { "id" : 2 } }]), fetch(all, 2));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), tbl.get(1).update({ "version" : 1 }));
		@:await assertAtom([{ "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "version" : 1 } }], fetch(all, 1));
		@:await assertAtom(partial({ "errors" : 0, "deleted" : 1 }), tbl.get(1).delete());
		@:await assertAtom([{ "old_val" : { "id" : 1, "version" : 1 }, "new_val" : null }], fetch(all, 1));
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), tbl.insert([{ "id" : 5, "version" : 5 }]));
		@:await assertAtom([{ "new_val" : { "version" : 5 } }], fetch(pluck, 1));
		@:await assertError("ReqlQueryLogicError", "Cannot call a terminal (`reduce`, `count`, etc.) on an infinite stream (such as a changefeed).", tbl.changes().orderBy("id"));
		@:await assertAtom(partial([{ "error" : regex("Changefeed cache over array size limit, skipped \d+ elements.") }]), fetch(overflow, 90));
		var vtbl = r.db("rethinkdb").table("_debug_scratch");
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 2 }), vtbl.insert([{ "id" : 1 }, { "id" : 2 }]));
		@:await assertAtom(bag([{ "old_val" : null, "new_val" : { "id" : 1 } }, { "old_val" : null, "new_val" : { "id" : 2 } }]), fetch(allVirtual, 2));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), vtbl.get(1).update({ "version" : 1 }));
		@:await assertAtom([{ "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "version" : 1 } }], fetch(allVirtual, 1));
		@:await assertAtom(partial({ "errors" : 0, "deleted" : 1 }), vtbl.get(1).delete());
		@:await assertAtom([{ "old_val" : { "id" : 1, "version" : 1 }, "new_val" : null }], fetch(allVirtual, 1));
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), vtbl.insert([{ "id" : 5, "version" : 5 }]));
		@:await assertAtom([{ "new_val" : { "version" : 5 } }], fetch(vpluck, 1));
		@:await dropTables(_tables);
		return Noise;
	}
}