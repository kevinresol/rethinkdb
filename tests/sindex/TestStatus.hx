package sindex;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestStatus extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom({ "created" : 1 }, tbl2.indexCreate("a"));
			@:await assertAtom({ "created" : 1 }, tbl2.indexCreate("b"));
			@:await assertAtom(2, tbl2.indexStatus().count());
			@:await assertAtom(1, tbl2.indexStatus("a").count());
			@:await assertAtom(1, tbl2.indexStatus("b").count());
			@:await assertAtom(2, tbl2.indexStatus("a", "b").count());
			@:await assertAtom({ "dropped" : 1 }, tbl2.indexDrop("a"));
			@:await assertAtom({ "dropped" : 1 }, tbl2.indexDrop("b"));
			@:await assertPartial({ "inserted" : 5000 }, tbl2.insert(r.range(0, 5000).map({ "a" : r.row })));
			@:await assertAtom({ "created" : 1 }, tbl2.indexCreate("foo"));
			@:await assertAtom([true, true], tbl2.indexWait()["ready"]);
			@:await assertBag([false, false], tbl2.indexWait()["geo"]);
			@:await assertBag([false, true], tbl2.indexWait()["multi"]);
			@:await assertAtom([false, false], tbl2.indexWait()["outdated"]);
			@:await assertAtom({ "created" : 1 }, tbl2.indexCreate("quux"));
			@:await assertAtom([{ "index" : "quux", "ready" : true }], tbl2.indexWait("quux").pluck("index", "ready"));
			@:await assertAtom("PTYPE<BINARY>", tbl2.indexWait("quux").nth(0).getField("function").typeOf());
		};
		return Noise;
	}
}