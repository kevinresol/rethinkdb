package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestSelection extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl", "tbl2", "tbl3"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl"), tbl2 = r.db("test").table("tbl2"), tbl3 = r.db("test").table("tbl3");
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 100 }), tbl.insert([for (i in xrange(100)) { "id" : i, "a" : i % 4 }]));
		@:await assertAtom(({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 100 }), tbl2.insert([for (i in xrange(100)) { "id" : i, "b" : i % 4 }]));
		@:await assertAtom("TABLE", tbl.typeOf());
		@:await assertError("ReqlOpFailedError", "Database `missing` does not exist.", r.db("missing").table("bar"));
		@:await assertError("ReqlOpFailedError", "Table `test.missing` does not exist.", r.db("test").table("missing"));
		@:await assertAtom(({ "errors" : 1, "inserted" : 0 }), tbl.insert({ "id" : "\x00" }).pluck("errors", "inserted"));
		@:await assertAtom(({ "errors" : 1, "inserted" : 0 }), tbl.insert({ "id" : ["embedded", ["null\x00"]] }).pluck("errors", "inserted"));
		@:await assertError("ReqlQueryLogicError", "Database name `%` invalid (Use A-Z, a-z, 0-9, _ and - only).", r.db("%"));
		@:await assertError("ReqlQueryLogicError", "Table name `%` invalid (Use A-Z, a-z, 0-9, _ and - only).", r.db("test").table("%"));
		@:await assertAtom(100, tbl.count());
		var tbl2Name = tbl2.info().getField("name");
		var tbl2DbName = tbl2.info().getField("db").getField("name");
		@:await assertAtom(100, r.db(tbl2DbName).table(tbl2Name, { "read_mode" : "outdated" }).count());
		@:await assertAtom(100, r.db(tbl2DbName).table(tbl2Name, { "read_mode" : "single" }).count());
		@:await assertAtom(100, r.db(tbl2DbName).table(tbl2Name, { "read_mode" : "majority" }).count());
		@:await assertError("ReqlNonExistenceError", "Expected type STRING but found NULL.", r.db(tbl2DbName).table(tbl2Name, { "read_mode" : null }).count());
		@:await assertError("ReqlQueryLogicError", "Expected type STRING but found BOOL.", r.db(tbl2DbName).table(tbl2Name, { "read_mode" : true }).count());
		@:await assertError("ReqlQueryLogicError", "Read mode `fake` unrecognized (options are \"majority\", \"single\", and \"outdated\").", r.db(tbl2DbName).table(tbl2Name, { "read_mode" : "fake" }).count());
		@:await assertAtom(2, tbl.get(20).count());
		@:await assertAtom({ "id" : 20, "a" : 0 }, tbl.get(20));
		@:await assertAtom(null, tbl.get(2000));
		@:await assertError("ReqlCompileError", "Expected 2 arguments but found 1.", tbl.get());
		@:await assertError("ReqlCompileError", "Expected 2 arguments but found 3.", tbl.get(10, 20));
		@:await assertPartial({ "tables_created" : 1 }, r.db("test").tableCreate("testpkey", { "primary_key" : "foo" }));
		var tblpkey = r.db("test").table("testpkey");
		@:await assertAtom({ "deleted" : 0.0, "replaced" : 0.0, "unchanged" : 0.0, "errors" : 0.0, "skipped" : 0.0, "inserted" : 1 }, tblpkey.insert({ "foo" : 10, "a" : 10 }));
		@:await assertAtom({ "foo" : 10, "a" : 10 }, tblpkey.get(10));
		@:await assertAtom([], tbl.getAll());
		@:await assertAtom([{ "id" : 20, "a" : 0 }], tbl.getAll(20));
		@:await assertAtom("SELECTION<STREAM>", tbl.getAll().typeOf());
		@:await assertAtom("SELECTION<STREAM>", tbl.getAll(20).typeOf());
		@:await assertAtom("TABLE_SLICE", tbl.between(2, 1).typeOf());
		@:await assertAtom("TABLE_SLICE", tbl.between(1, 2).typeOf());
		@:await assertAtom("TABLE_SLICE", tbl.between(1, 2, { "index" : "id" }).typeOf());
		@:await assertAtom("TABLE_SLICE", tbl.between(1, 1, { "right_bound" : "closed" }).typeOf());
		@:await assertAtom("TABLE_SLICE", tbl.between(2, 1).typeOf());
		@:await assertAtom("TABLE_SLICE", tbl.between(2, 1, { "index" : "id" }).typeOf());
		@:await assertAtom(0, tbl.between(21, 20).count());
		@:await assertAtom(9, tbl.between(20, 29).count());
		@:await assertAtom(9, tbl.between(-10, 9).count());
		@:await assertAtom(20, tbl.between(80, 2000).count());
		@:await assertAtom(100, tbl.between(-2000, 2000).count());
		@:await assertAtom(10, tbl.between(20, 29, { "right_bound" : "closed" }).count());
		@:await assertAtom(10, tbl.between(-10, 9, { "right_bound" : "closed" }).count());
		@:await assertAtom(20, tbl.between(80, 2000, { "right_bound" : "closed" }).count());
		@:await assertAtom(100, tbl.between(-2000, 2000, { "right_bound" : "closed" }).count());
		@:await assertAtom(8, tbl.between(20, 29, { "left_bound" : "open" }).count());
		@:await assertAtom(9, tbl.between(-10, 9, { "left_bound" : "open" }).count());
		@:await assertAtom(19, tbl.between(80, 2000, { "left_bound" : "open" }).count());
		@:await assertAtom(100, tbl.between(-2000, 2000, { "left_bound" : "open" }).count());
		@:await assertError("ReqlQueryLogicError", "Expected type TABLE_SLICE but found DATUM:", r.expr([1, 2, 3]).between(-1, 2));
		@:await assertAtom(2, tbl.between(r.minval, 2).count());
		@:await assertAtom(3, tbl.between(r.minval, 2, { "right_bound" : "closed" }).count());
		@:await assertAtom(2, tbl.between(r.minval, 2, { "left_bound" : "open" }).count());
		@:await assertAtom(98, tbl.between(2, r.maxval).count());
		@:await assertError("ReqlCompileError", "Expected 3 arguments but found 2.", tbl.between(2).count());
		@:await assertError("ReqlQueryLogicError", "Cannot use `nu" + "ll` in BETWEEN, use `r.minval` or `r.maxval` to denote unboundedness.", tbl.between(null, 2).count());
		@:await assertError("ReqlQueryLogicError", "Cannot use `nu" + "ll` in BETWEEN, use `r.minval` or `r.maxval` to denote unboundedness.", tbl.between(2, null).count());
		@:await assertError("ReqlQueryLogicError", "Cannot use `nu" + "ll` in BETWEEN, use `r.minval` or `r.maxval` to denote unboundedness.", tbl.between(null, null).count());
		@:await assertAtom(1, tblpkey.between(9, 11).count());
		@:await assertAtom(0, tblpkey.between(11, 12).count());
		@:await assertAtom(100, tbl.filter(function(row) return 1).count());
		var nested = r.expr([[1, 2], [3, 4], [5, 6]]);
		@:await assertAtom([{ "a" : 1, "b" : 2, "c" : 3 }], r.expr([{ "a" : 1, "b" : 1, "c" : 3 }, { "a" : 1, "b" : 2, "c" : 3 }]).filter({ "a" : 1, "b" : 2 }));
		@:await assertAtom([{ "a" : 1, "b" : 1, "c" : 3 }, { "a" : 1, "b" : 2, "c" : 3 }], r.expr([{ "a" : 1, "b" : 1, "c" : 3 }, { "a" : 1, "b" : 2, "c" : 3 }]).filter({ "a" : 1 }));
		@:await assertAtom([{ "a" : 1, "b" : 1, "c" : 3 }], r.expr([{ "a" : 1, "b" : 1, "c" : 3 }, { "a" : 1, "b" : 2, "c" : 3 }]).filter({ "a" : r.row["b"] }));
		@:await assertAtom([], r.expr([{ "a" : 1 }]).filter({ "b" : 1 }));
		@:await assertAtom(25, tbl.count(function(row) return { "a" : 1 }));
		@:await assertAtom(2, r.expr([1, 2, 3, 1]).count(1));
		@:await assertAtom(2, r.expr([null, 4, null, "foo"]).count(null));
		@:await assertError("ReqlQueryLogicError", "Expected type DATUM but found TABLE:", r.expr(5) + tbl);
		@:await assertAtom("SELECTION<STREAM>", tbl.hasFields("field").typeOf());
		@:await dropTables(_tables);
		return Noise;
	}
}