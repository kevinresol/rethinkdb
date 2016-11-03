package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestSync extends TestBase {
	override function test() {
		assertAtom(partial({ tables_created : 1 }), r.db("test").tableCreate("test1"));
		assertAtom(partial({ tables_created : 1 }), r.db("test").tableCreate("test1soft"));
		var tbl = r.db("test").table("test1");
		var tbl_soft = r.db("test").table("test1soft");
		assertAtom(partial({ created : 1 }), tbl.indexCreate("x"));
		assertAtom(partial({ tables_dropped : 1 }), r.db("test").tableDrop("test1"));
		assertAtom(partial({ tables_dropped : 1 }), r.db("test").tableDrop("test1soft"));
	}
}