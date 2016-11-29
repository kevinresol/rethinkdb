package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestReplace extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 100 }), tbl.insert(([for (i in xrange(100)) { "id" : i }] : Array<Dynamic>)));
		@:await assertAtom(100, tbl.count());
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(12).replace(function(row:Expr):Expr return { "id" : row["id"] }));
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(12).replace(function(row:Expr):Expr return { "id" : row["id"], "a" : row["id"] }));
		@:await assertAtom(({ "deleted" : 1, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(13).replace(function(row:Expr):Expr return null));
		@:await assertAtom(({ "first_error" : "Inserted object must have primary key `id`:\n{\n\t\\"a\\":\t1\n}", "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 10, "skipped" : 0.0, "inserted" : 0.0 }), tbl.between(10, 20, { "right_bound" : "closed" }).replace(function(row:Expr):Expr return { "a" : 1 }));
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 8, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.filter(function(row:Expr):Expr return (row["id"] >= 10) & (row["id"] < 20)).replace(function(row:Expr):Expr return { "id" : row["id"], "a" : row["id"] }));
		@:await assertAtom(({ "first_error" : "Primary key `id` cannot be changed (`{\n\t\"id\":\t1\n}` -> `{\n\t\"a\":\t1,\n\t\"id\":\t2\n}`).", "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 1, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(1).replace({ "id" : 2, "a" : 1 }));
		@:await assertAtom(({ "first_error" : "Inserted object must have primary key `id`:\n{\n\t\"a\":\t1\n}", "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 1, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(1).replace({ "a" : 1 }));
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(1).replace({ "id" : r.row["id"], "a" : "b" }));
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(1).replace(r.row.merge({ "a" : "b" })));
		@:await assertError(err("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", ([0] : Array<Dynamic>)), tbl.get(1).replace(r.row.merge({ "c" : r.js("5") })));
		@:await assertError(err("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", ([0] : Array<Dynamic>)), tbl.get(1).replace(r.row.merge({ "c" : tbl.nth(0) })));
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.get(1).replace(r.row.merge({ "c" : r.js("5") }), { "non_atomic" : true }));
		@:await assertAtom(({ "deleted" : 99, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }), tbl.replace(function(row:Expr):Expr return null));
		@:await assertAtom(1, tbl.get("sdfjk").replace({ "id" : "sdfjk" })["inserted"]);
		@:await assertAtom(1, tbl.get("sdfjki").replace({ "id" : "sdfjk" })["errors"]);
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 1, "inserted" : 0.0 }), tbl.get("non-existant").replace(null));
		@:await dropTables(_tables);
		return Noise;
	}
}