package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test370 extends TestBase {
	override function test() {
		var d = r.db("test");
		assertAtom(["rethinkdb", "test"], r.dbList().map(r.row));
		assertAtom(["t370"], d.tableList().map(r.row));
	}
}