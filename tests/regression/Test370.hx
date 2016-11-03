package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test370 extends TestBase {
	override function test() {
		assertAtom(null, r.db("test").tableCreate("t370"));
		var d = r.db("test");
		assertAtom((["rethinkdb", "test"]), r.dbList().map(r.row));
		assertAtom((["t370"]), d.tableList().map(r.row));
		assertAtom(null, r.db("test").tableDrop("t370"));
	}
}