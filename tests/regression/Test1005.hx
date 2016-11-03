package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1005 extends TestBase {
	override function test() {
		assertAtom(r.tableList(), r.expr(str(r.tableList())));
		assertAtom(r.tableCreate("a"), r.expr(str(r.tableCreate("a"))));
		assertAtom(r.tableDrop("a"), r.expr(str(r.tableDrop("a"))));
		assertAtom(r.db("a").tableList(), r.expr(str(r.db("a").tableList())));
		assertAtom(r.db("a").tableCreate("a"), r.expr(str(r.db("a").tableCreate("a"))));
		assertAtom(r.db("a").tableDrop("a"), r.expr(str(r.db("a").tableDrop("a"))));
	}
}