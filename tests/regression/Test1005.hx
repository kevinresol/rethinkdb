package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1005 extends TestBase {
	override function test() {
		assertAtom("r.table_list()", r.expr(str(r.tableList())));
		assertAtom("r.table_create(\'a\')", r.expr(str(r.tableCreate("a"))));
		assertAtom("r.table_drop(\'a\')", r.expr(str(r.tableDrop("a"))));
		assertAtom("r.db(\'a\').table_list()", r.expr(str(r.db("a").tableList())));
		assertAtom("r.db(\'a\').table_create(\'a\')", r.expr(str(r.db("a").tableCreate("a"))));
		assertAtom("r.db(\'a\').table_drop(\'a\')", r.expr(str(r.db("a").tableDrop("a"))));
	}
}