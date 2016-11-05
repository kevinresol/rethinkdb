package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestReplace extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(100, tbl.count());
			@:await assertAtom({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).replace(function(row) return { "id" : row["id"] }));
			@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(12).replace(function(row) return { "id" : row["id"], "a" : row["id"] }));
			@:await assertAtom({ "deleted" : 1, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(13).replace(function(row) return null));
			@:await assertAtom({ "first_error" : "Inserted object must have primary key `id`:\\n{\\n\\t\\\\"a\\\\":\\t1\\n}", "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 10, "skipped" : 0.0, "inserted" : 0.0 }, tbl.between(10, 20, { "right_bound" : "closed" }).replace(function(row) return { "a" : 1 }));
			@:await assertAtom({ "deleted" : 0.0, "replaced" : 1, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(1).replace({ "id" : r.row["id"], "a" : "b" }));
			@:await assertAtom({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 1, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.get(1).replace(r.row.merge({ "a" : "b" })));
			@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).replace(r.row.merge({ "c" : r.js("5") })));
			@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).replace(r.row.merge({ "c" : tbl.nth(0) })));
			@:await assertError("ReqlCompileError", "Expected 2 arguments but found 3.", tbl.get(1).replace({  }, "foo"));
			@:await assertError("ReqlCompileError", "Unrecognized optional argument `foo`.", tbl.get(1).replace({  }, { "foo" : "bar" }));
			@:await assertAtom({ "deleted" : 99, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 0.0 }, tbl.replace(function(row) return null));
			@:await assertAtom(1, tbl.get("sdfjk").replace({ "id" : "sdfjk" })["inserted"]);
			@:await assertAtom(1, tbl.get("sdfjki").replace({ "id" : "sdfjk" })["errors"]);
			@:await assertAtom({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 1, "inserted" : 0.0 }, tbl.get("non-existant").replace(null));
		};
		return Noise;
	}
}