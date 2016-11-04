package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test46 extends TestBase {
	override function test() {
		assertAtom("partial({\'tables_created\':1})", r.tableCreate("46"));
		assertAtom(["46"], r.tableList());
		assertAtom("partial({\'tables_dropped\':1})", r.tableDrop("46"));
	}
}