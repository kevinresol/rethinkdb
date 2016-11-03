package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2767 extends TestBase {
	override function test() {
		assertAtom(null, tbl.indexWait());
	}
}