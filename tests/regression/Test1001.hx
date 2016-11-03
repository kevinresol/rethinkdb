package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1001 extends TestBase {
	override function test() {
		assertAtom(null, tbl.insert({ a : null }));
		assertAtom(null, tbl.indexCreate("a"));
		assertAtom(null, tbl.indexCreate("b"));
		assertAtom(null, tbl.indexWait().pluck("index", "ready"));
		assertAtom(1, tbl.between(r.minval, r.maxval).count());
		assertAtom(0, tbl.between(r.minval, r.maxval, { "index" : "a" }).count());
		assertAtom(0, tbl.between(r.minval, r.maxval, { "index" : "b" }).count());
	}
}