package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestInsert extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "tables_created" : 1 }), r.db("test").tableCreate("test2"));
		var tbl2 = r.db("test").table("test2");
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 0, "a" : 0 }));
		@:await assertAtom(1, tbl.count());
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 1, "a" : 1 }, { "durability" : "hard" }));
		@:await assertAtom(2, tbl.count());
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 2, "a" : 2 }, { "durability" : "soft" }));
		@:await assertAtom(3, tbl.count());
		@:await assertError(err("ReqlQueryLogicError", "Durability option `wrong` unrecognized (options are \"hard\" and \"soft\").", [0]), tbl.insert({ "id" : 3, "a" : 3 }, { "durability" : "wrong" }));
		@:await assertAtom(3, tbl.count());
		@:await assertAtom({ "deleted" : 1, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }, tbl.get(2).delete());
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 2 }, tbl.insert([{ "id" : 2, "a" : 2 }, { "id" : 3, "a" : 3 }]));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 4 }, tbl2.insert(tbl));
		@:await assertAtom({ "first_error" : "Duplicate primary key `id`:\n{\n\t\"a\":\t2,\n\t\"id\":\t2\n}\n{\n\t\"b\":\t20,\n\t\"id\":\t2\n}", "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 1, "skipped" : 0, "inserted" : 0 }, tbl.insert({ "id" : 2, "b" : 20 }));
		@:await assertAtom({ "first_error" : "Duplicate primary key `id`:\n{\n\t\"a\":\t2,\n\t\"id\":\t2\n}\n{\n\t\"b\":\t20,\n\t\"id\":\t2\n}", "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 1, "skipped" : 0, "inserted" : 0 }, tbl.insert({ "id" : 2, "b" : 20 }, { "conflict" : "error" }));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 15, "b" : 20 }, { "conflict" : "error" }));
		@:await assertAtom({ "id" : 15, "b" : 20 }, tbl.get(15));
		@:await assertAtom({ "deleted" : 0, "replaced" : 1, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }, tbl.insert({ "id" : 2, "b" : 20 }, { "conflict" : "replace" }));
		@:await assertAtom({ "id" : 2, "b" : 20 }, tbl.get(2));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 20, "b" : 20 }, { "conflict" : "replace" }));
		@:await assertAtom({ "id" : 20, "b" : 20 }, tbl.get(20));
		@:await assertAtom({ "deleted" : 0, "replaced" : 1, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }, tbl.insert({ "id" : 2, "c" : 30 }, { "conflict" : "update" }));
		@:await assertAtom({ "id" : 2, "b" : 20, "c" : 30 }, tbl.get(2));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 30, "b" : 20 }, { "conflict" : "update" }));
		@:await assertAtom({ "id" : 30, "b" : 20 }, tbl.get(30));
		@:await assertError(err("ReqlQueryLogicError", "Conflict option `wrong` unrecognized (options are \"error\", \"replace\" and \"update\").", [0]), tbl.insert({ "id" : 3, "a" : 3 }, { "conflict" : "wrong" }));
		@:await assertAtom(partial({ "tables_created" : 1 }), r.db("test").tableCreate("testpkey", { "primary_key" : "foo" }));
		var tblpkey = r.db("test").table("testpkey");
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "generated_keys" : arrlen(1, uuid()), "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tblpkey.insert({  }));
		@:await assertAtom([{ "foo" : uuid() }], tblpkey);
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "generated_keys" : arrlen(1, uuid()), "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tblpkey.insert({ "b" : 20 }, { "conflict" : "replace" }));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "generated_keys" : arrlen(1, uuid()), "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tblpkey.insert({ "b" : 20 }, { "conflict" : "update" }));
		@:await assertAtom(partial({ "tables_dropped" : 1 }), r.db("test").tableDrop("testpkey"));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 7 }, tbl.forEach(function(row:Expr):Expr return tbl2.insert(row.merge({ "id" : row["id"] + 100 }))));
		@:await assertAtom(partial({ "errors" : 1, "first_error" : "`r.minval` and `r.maxval` cannot be written to disk." }), tbl.insert({ "value" : r.minval }));
		@:await assertAtom(partial({ "errors" : 1, "first_error" : "`r.minval` and `r.maxval` cannot be written to disk." }), tbl.insert({ "value" : r.maxval }));
		@:await assertAtom(partial({ "changes" : [for (i in range(1, 100)) { "old_val" : { "id" : 100 + i, "ordered-num" : i }, "new_val" : { "id" : 100 + i, "ordered-num" : i }, "error" : "Duplicate primary key `id`:\n{\n\t\"id\":\t" + str(100 + i) + ",\n\t\"ordered-num\":\t" + str(i) + "\n}\n{\n\t\"id\":\t" + str(100 + i) + ",\n\t\"ordered-num\":\t" + str(i) + "\n}" }] }), tbl.insert([for (i in range(1, 100)) { "id" : 100 + i, "ordered-num" : i }], { "return_changes" : "always" }));
		@:await assertAtom(partial({ "changes" : [] }), tbl.insert([for (i in range(1, 100)) { "id" : 100 + i, "ordered-num" : i }], { "return_changes" : true }));
		@:await assertAtom(partial({ "inserted" : 1 }), tbl.insert({ "id" : 42, "foo" : 1, "bar" : 1 }));
		@:await assertAtom(partial({ "replaced" : 1 }), tbl.insert({ "id" : 42, "foo" : 5, "bar" : 5 }, { "conflict" : function(id:Expr, old_row:Expr, new_row:Expr):Expr return old_row.merge(new_row.pluck("bar")) }));
		@:await assertAtom({ "id" : 42, "foo" : 1, "bar" : 5 }, tbl.get(42));
		@:await assertAtom(partial({ "first_error" : "Inserted value must be an OBJECT (got NUMBER):\n2" }), tbl.insert({ "id" : 42, "foo" : 1, "bar" : 1 }, { "conflict" : function(a:Expr, b:Expr, c:Expr):Expr return 2 }));
		@:await assertError(err("ReqlQueryLogicError", "The conflict function passed to `insert` should expect 3 arguments."), tbl.insert({ "id" : 42 }, { "conflict" : function(a:Expr, b:Expr):Expr return a }));
		@:await assertError(err("ReqlQueryLogicError", "The conflict function passed to `insert` must be deterministic."), tbl.insert({ "id" : 42 }, { "conflict" : function(a:Expr, b:Expr, c:Expr):Expr return tbl.get(42) }));
		@:await assertAtom(partial({ "replaced" : 1 }), tbl.insert({ "id" : 42 }, { "conflict" : function(a:Expr, b:Expr, c:Expr):Expr return { "id" : 42, "num" : "424" } }));
		@:await assertAtom({ "id" : 42, "num" : "424" }, tbl.get(42));
		@:await assertError(err("ReqlQueryLogicError", "Cannot convert `r.minval` to JSON."), r.minval);
		@:await assertError(err("ReqlQueryLogicError", "Cannot convert `r.maxval` to JSON."), r.maxval);
		@:await assertAtom(partial({ "tables_dropped" : 1 }), r.db("test").tableDrop("test2"));
		@:await dropTables(_tables);
		return Noise;
	}
}