package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestSync extends TestBase {
	override function test() {
		assertAtom("partial({\'tables_created\':1})", r.db("test").tableCreate("test1"));
		assertAtom("partial({\'tables_created\':1})", r.db("test").tableCreate("test1soft"));
		assertAtom({ "skipped" : 0, "deleted" : 0, "unchanged" : 0, "errors" : 0, "replaced" : 1, "inserted" : 0 }, r.db("test").table("test1soft").config().update({ "durability" : "soft" }));
		var tbl = r.db("test").table("test1");
		var tbl_soft = r.db("test").table("test1soft");
		assertAtom("partial({\'created\':1})", tbl.indexCreate("x"));
		assertAtom([{ "ready" : true, "index" : "x" }], tbl.indexWait("x").pluck("index", "ready"));
		assertAtom({ "synced" : 1 }, tbl.sync());
		assertAtom({ "synced" : 1 }, tbl_soft.sync());
		assertAtom({ "synced" : 1 }, tbl.sync());
		assertAtom({ "synced" : 1 }, tbl.sync());
		assertError("AttributeError", "\'Between\' object has no attribute \'sync\'", tbl.between(1, 2).sync());
		assertError("AttributeError", "\'Datum\' object has no attribute \'sync\'", r.expr(1).sync());
		assertAtom("partial({\'tables_dropped\':1})", r.db("test").tableDrop("test1"));
		assertAtom("partial({\'tables_dropped\':1})", r.db("test").tableDrop("test1soft"));
	}
}