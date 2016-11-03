package .meta;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestComposite.py extends TestBase {
	override function test() {
		assertAtom(({ dbs_created : 3, config_changes : arrlen(3) }), r.expr([1, 3]).forEach(r.dbCreate("db_" + r.row.coerceTo("string"))));
		assertAtom(partial({ tables_created : 9 }), r.dbList().setDifference(["rethinkdb", "test"]).forEach(function(db_name) return r.expr([1, 3]).forEach(function(i) return r.db(db_name).tableCreate("tbl_" + i.coerceTo("string")))));
		assertAtom(partial({ dbs_dropped : 3, tables_dropped : 9 }), r.dbList().setDifference(["rethinkdb", "test"]).forEach(r.dbDrop(r.row)));
	}
}