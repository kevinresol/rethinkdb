package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestUpdate extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl", "tbl2"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl"), tbl2 = r.db("test").table("tbl2");
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 100 }), tbl.insert([for (i in xrange(100)) { "id" : i }]));
		@:await assertAtom(100, tbl.count());
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 100 }), tbl2.insert([for (i in xrange(100)) { "id" : i, "foo" : { "bar" : i } }]));
		@:await assertAtom(100, tbl2.count());
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).update(function(row) return row));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).update(function(row) return { "a" : row["id"] + 1 }, { "durability" : "soft" }));
		@:await assertAtom({ "id" : 12, "a" : 13 }, tbl.get(12));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).update(function(row) return { "a" : row["id"] + 2 }, { "durability" : "hard" }));
		@:await assertAtom({ "id" : 12, "a" : 14 }, tbl.get(12));
		@:await assertError("ReqlQueryLogicError", "Durability option `wrong` unrecognized (options are \"hard\" and \"soft\").", tbl.get(12).update(function(row) return { "a" : row["id"] + 3 }, { "durability" : "wrong" }));
		@:await assertAtom({ "id" : 12, "a" : 14 }, tbl.get(12));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).update(function(row) return { "a" : row["id"] }));
		@:await assertAtom({ "id" : 12, "a" : 12 }, tbl.get(12));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).update({ "a" : r.literal() }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 10, "unchanged" : 0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.between(10, 20).update(function(row) return { "a" : row["id"] }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 10, "unchanged" : 0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.between(10, 20).update({ "a" : r.literal() }));
		@:await assertAtom({ "first_error" : "Primary key `id` cannot be changed (`{\n\t\"id\":\t1\n}` -> `{\n\t\"d\":\t1,\n\t\"id\":\t2\n}`).", "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 1, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(1).update({ "id" : 2, "d" : 1 }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(1).update({ "id" : r.row["id"], "d" : "b" }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(1).update(r.row.merge({ "d" : "b" })));
		@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).update({ "d" : r.js("5") }));
		@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).update({ "d" : tbl.nth(0) }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(1).update({ "d" : r.js("5") }, { "non_atomic" : true }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 100, "unchanged" : 0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.update(function(row) return { "a" : row["id"] }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 100, "unchanged" : 0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.update({ "a" : r.literal() }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 99, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl2.update({ "foo" : { "bar" : 2 } }));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 0, "unchanged" : 100, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl2.update({ "foo" : r.literal({ "bar" : 2 }) }));
		@:await assertAtom({ "id" : 0, "foo" : { "bar" : 2 } }, tbl2.orderBy("id").nth(0));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 100, "unchanged" : 0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl2.update({ "foo" : { "buzz" : 2 } }));
		@:await assertAtom({ "id" : 0, "foo" : { "bar" : 2, "buzz" : 2 } }, tbl2.orderBy("id").nth(0));
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 100, "unchanged" : 0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl2.update({ "foo" : r.literal(1) }));
		@:await assertAtom({ "id" : 0, "foo" : 1 }, tbl2.orderBy("id").nth(0));
		@:await dropTables(_tables);
		return Noise;
	}
}