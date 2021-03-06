package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestAtomic_get_set extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertError(err("ReqlQueryLogicError", "Error:" + " encountered obsolete optarg `return_vals`.  Use `return_changes` instead.", ([0] : Array<Dynamic>)), tbl.insert({ "id" : 0 }, { "return_vals" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([{ "old_val" : null, "new_val" : { "id" : 0 } }] : Array<Dynamic>) }), tbl.insert({ "id" : 0 }, { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([] : Array<Dynamic>), "first_error" : "Duplicate primary key `id`:\n{\n\t\"id\":\t0\n}\n{\n\t\"id\":\t0\n}" }), tbl.insert({ "id" : 0 }, { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "first_error" : "Duplicate primary key `id`:\n{\n\t\"id\":\t0\n}\n{\n\t\"id\":\t0\n}", "changes" : ([{ "old_val" : { "id" : 0 }, "new_val" : { "id" : 0 }, "error" : "Duplicate primary key `id`:\n{\n\t\"id\":\t0\n}\n{\n\t\"id\":\t0\n}" }] : Array<Dynamic>) }), tbl.insert({ "id" : 0 }, { "return_changes" : "always" }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([{ "new_val" : { "id" : 1 }, "old_val" : null }] : Array<Dynamic>), "errors" : 0, "deleted" : 0, "unchanged" : 0, "skipped" : 0, "replaced" : 0, "inserted" : 1 }), tbl.insert(([{ "id" : 1 }] : Array<Dynamic>), { "return_changes" : true }));
		@:await assertAtom(({ "changes" : ([] : Array<Dynamic>), "first_error" : "Duplicate primary key `id`:\n{\n\t\"id\":\t0\n}\n{\n\t\"id\":\t0\n}" }), tbl.insert(([{ "id" : 0 }] : Array<Dynamic>), { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([{ "old_val" : { "id" : 0 }, "new_val" : { "id" : 0, "x" : 1 } }] : Array<Dynamic>) }), tbl.get(0).update({ "x" : 1 }, { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([] : Array<Dynamic>), "first_error" : "a" }), tbl.get(0).update({ "x" : r.error("a") }, { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([{ "old_val" : { "id" : 0, "x" : 1 }, "new_val" : { "id" : 0, "x" : 3 } }, { "old_val" : { "id" : 1 }, "new_val" : { "id" : 1, "x" : 3 } }] : Array<Dynamic>) }), tbl.update({ "x" : 3 }, { "return_changes" : true }).pluck("changes", "first_error").do_(function(d:Expr):Expr return d.merge({ "changes" : d["changes"].orderBy(function(a:Expr):Expr return a["old_val"]["id"]) })));
		@:await assertAtom(({ "changes" : ([{ "old_val" : { "id" : 0, "x" : 3 }, "new_val" : { "id" : 0, "x" : 2 } }] : Array<Dynamic>) }), tbl.get(0).replace({ "id" : 0, "x" : 2 }, { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([] : Array<Dynamic>), "first_error" : "a" }), tbl.get(0).replace(function(y:Expr):Expr return { "x" : r.error("a") }, { "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "first_error" : "a", "changes" : ([{ "old_val" : { "id" : 0, "x" : 2 }, "new_val" : { "id" : 0, "x" : 2 }, "error" : "a" }] : Array<Dynamic>) }), tbl.get(0).replace(function(y:Expr):Expr return { "x" : r.error("a") }, { "return_changes" : "always" }).pluck("changes", "first_error"));
		@:await assertAtom(({ "changes" : ([{ "new_val" : { "id" : 0 }, "old_val" : { "id" : 0, "x" : 2 } }, { "new_val" : { "id" : 1 }, "old_val" : { "id" : 1, "x" : 3 } }] : Array<Dynamic>) }), tbl.replace(function(y:Expr):Expr return y.without("x"), { "return_changes" : true }).pluck("changes", "first_error").do_(function(d:Expr):Expr return d.merge({ "changes" : d["changes"].orderBy(function(a:Expr):Expr return a["old_val"]["id"]) })));
		@:await assertAtom(({ "first_error" : "Inserted object must have primary key `id`:\n{\n\t\"x\":\t1\n}", "changes" : ([{ "new_val" : { "id" : 0 }, "old_val" : { "id" : 0 }, "error" : "Inserted object must have primary key `id`:\n{\n\t\"x\":\t1\n}" }, { "new_val" : { "id" : 1 }, "old_val" : { "id" : 1 }, "error" : "Inserted object must have primary key `id`:\n{\n\t\"x\":\t1\n}" }] : Array<Dynamic>) }), tbl.replace({ "x" : 1 }, { "return_changes" : "always" }).pluck("changes", "first_error").do_(function(d:Expr):Expr return d.merge({ "changes" : d["changes"].orderBy(function(a:Expr):Expr return a["old_val"]["id"]) })));
		@:await assertAtom(({ "changes" : ([{ "old_val" : { "id" : 0 }, "new_val" : null }] : Array<Dynamic>) }), tbl.get(0).delete({ "return_changes" : true }).pluck("changes", "first_error"));
		@:await assertAtom(({ "deleted" : 1, "errors" : 0, "inserted" : 0, "replaced" : 0, "skipped" : 0, "unchanged" : 0, "changes" : ([{ "new_val" : null, "old_val" : { "id" : 1 } }] : Array<Dynamic>) }), tbl.delete({ "return_changes" : true }));
		@:await dropTables(_tables);
		return Noise;
	}
}