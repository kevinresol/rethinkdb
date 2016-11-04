package sindex;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestStatus extends TestBase {
	override function test() {
		assertAtom({ "created" : 1 }, tbl2.indexCreate("a"));
		assertAtom({ "created" : 1 }, tbl2.indexCreate("b"));
		assertAtom(2, tbl2.indexStatus().count());
		assertAtom(1, tbl2.indexStatus("a").count());
		assertAtom(1, tbl2.indexStatus("b").count());
		assertAtom(2, tbl2.indexStatus("a", "b").count());
		assertAtom({ "dropped" : 1 }, tbl2.indexDrop("a"));
		assertAtom({ "dropped" : 1 }, tbl2.indexDrop("b"));
		assertAtom("partial({\'inserted\':5000})", tbl2.insert(r.range(0, 5000).map({ "a" : r.row })));
		assertAtom({ "created" : 1 }, tbl2.indexCreate("foo"));
		assertAtom([true, true], tbl2.indexWait()["ready"]);
		assertAtom("bag([false, false])", tbl2.indexWait()["geo"]);
		assertAtom("bag([false, true])", tbl2.indexWait()["multi"]);
		assertAtom([false, false], tbl2.indexWait()["outdated"]);
		assertAtom({ "created" : 1 }, tbl2.indexCreate("quux"));
		assertAtom([{ "index" : "quux", "ready" : true }], tbl2.indexWait("quux").pluck("index", "ready"));
		assertAtom("PTYPE<BINARY>", tbl2.indexWait("quux").nth(0).getField("function").typeOf());
	}
}