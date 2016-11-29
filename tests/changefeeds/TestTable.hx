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
		var all = tbl.changes();
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 2 }), tbl.insert(([{ "id" : 1 }, { "id" : 2 }] : Array<Dynamic>)));
		@:await assertAtom(bag(([{ "old_val" : null, "new_val" : { "id" : 1 } }, { "old_val" : null, "new_val" : { "id" : 2 } }] : Array<Dynamic>)), fetch(all, 2));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), tbl.get(1).update({ "version" : 1 }));
		@:await assertAtom(([{ "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "version" : 1 } }] : Array<Dynamic>), fetch(all, 1));
		@:await assertAtom(partial({ "errors" : 0, "deleted" : 1 }), tbl.get(1).delete());
		@:await assertAtom(([{ "old_val" : { "id" : 1, "version" : 1 }, "new_val" : null }] : Array<Dynamic>), fetch(all, 1));
		var pluck = tbl.changes().pluck({ "new_val" : (["version"] : Array<Dynamic>) });
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), tbl.insert(([{ "id" : 5, "version" : 5 }] : Array<Dynamic>)));
		@:await assertAtom(([{ "new_val" : { "version" : 5 } }] : Array<Dynamic>), fetch(pluck, 1));
		@:await assertError(err("ReqlQueryLogicError", "Cannot call a terminal (`reduce`, `count`, etc.) on an infinite stream (such as a changefeed)."), tbl.changes().orderBy("id"));
		var overflow = tbl.changes();
		tbl.insert(r.range(200).map(function(x:Expr):Expr return {  }));
		@:await assertAtom(partial(([{ "error" : regex("Changefeed cache over array size limit, skipped \d+ elements.") }] : Array<Dynamic>)), fetch(overflow, 90));
		var vtbl = r.db("rethinkdb").table("_debug_scratch");
		var allVirtual = vtbl.changes();
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 2 }), vtbl.insert(([{ "id" : 1 }, { "id" : 2 }] : Array<Dynamic>)));
		@:await assertAtom(bag(([{ "old_val" : null, "new_val" : { "id" : 1 } }, { "old_val" : null, "new_val" : { "id" : 2 } }] : Array<Dynamic>)), fetch(allVirtual, 2));
		@:await assertAtom(partial({ "errors" : 0, "replaced" : 1 }), vtbl.get(1).update({ "version" : 1 }));
		@:await assertAtom(([{ "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "version" : 1 } }] : Array<Dynamic>), fetch(allVirtual, 1));
		@:await assertAtom(partial({ "errors" : 0, "deleted" : 1 }), vtbl.get(1).delete());
		@:await assertAtom(([{ "old_val" : { "id" : 1, "version" : 1 }, "new_val" : null }] : Array<Dynamic>), fetch(allVirtual, 1));
		var vpluck = vtbl.changes().pluck({ "new_val" : (["version"] : Array<Dynamic>) });
		@:await assertAtom(partial({ "errors" : 0, "inserted" : 1 }), vtbl.insert(([{ "id" : 5, "version" : 5 }] : Array<Dynamic>)));
		@:await assertAtom(([{ "new_val" : { "version" : 5 } }] : Array<Dynamic>), fetch(vpluck, 1));
		@:await dropTables(_tables);
		return Noise;
	}
}