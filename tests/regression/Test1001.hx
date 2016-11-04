package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1001 extends TestBase {
	override function test() {
		assertAtom(1, tbl.between(r.minval, r.maxval).count());
		assertAtom(0, tbl.between(r.minval, r.maxval, { "index" : "a" }).count());
		assertAtom(0, tbl.between(r.minval, r.maxval, { "index" : "b" }).count());
	}
}