package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestSync extends TestBase {
	@:async
	override function test() {
		{
			@:await assertPartial({ "tables_created" : 1 }, r.db("test").tableCreate("test1"));
			@:await assertPartial({ "tables_created" : 1 }, r.db("test").tableCreate("test1soft"));
			@:await assertAtom({ "skipped" : 0, "deleted" : 0, "unchanged" : 0, "errors" : 0, "replaced" : 1, "inserted" : 0 }, r.db("test").table("test1soft").config().update({ "durability" : "soft" }));
			var tbl = r.db("test").table("test1");
			var tbl_soft = r.db("test").table("test1soft");
			@:await assertPartial({ "created" : 1 }, tbl.indexCreate("x"));
			@:await assertAtom([{ "ready" : true, "index" : "x" }], tbl.indexWait("x").pluck("index", "ready"));
			@:await assertAtom({ "synced" : 1 }, tbl.sync());
			@:await assertAtom({ "synced" : 1 }, tbl_soft.sync());
			@:await assertAtom({ "synced" : 1 }, tbl.sync());
			@:await assertAtom({ "synced" : 1 }, tbl.sync());
			@:await assertError("AttributeError", "\'Between\' object has no attribute \'sync\'", tbl.between(1, 2).sync());
			@:await assertError("AttributeError", "\'Datum\' object has no attribute \'sync\'", r.expr(1).sync());
			@:await assertPartial({ "tables_dropped" : 1 }, r.db("test").tableDrop("test1"));
			@:await assertPartial({ "tables_dropped" : 1 }, r.db("test").tableDrop("test1soft"));
		};
		return Noise;
	}
}