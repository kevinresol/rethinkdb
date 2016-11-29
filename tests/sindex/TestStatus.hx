package sindex;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestStatus extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl2"];
		@:await createTables(_tables);
		var tbl2 = r.db("test").table("tbl2");
		@:await assertAtom(({ "created" : 1 }), tbl2.indexCreate("a"));
		@:await assertAtom(({ "created" : 1 }), tbl2.indexCreate("b"));
		@:await assertAtom(2, tbl2.indexStatus().count());
		@:await assertAtom(1, tbl2.indexStatus("a").count());
		@:await assertAtom(1, tbl2.indexStatus("b").count());
		@:await assertAtom(2, tbl2.indexStatus("a", "b").count());
		@:await assertAtom(({ "dropped" : 1 }), tbl2.indexDrop("a"));
		@:await assertAtom(({ "dropped" : 1 }), tbl2.indexDrop("b"));
		@:await assertAtom(partial({ "inserted" : 5000 }), tbl2.insert(r.range(0, 5000).map({ "a" : r.row })));
		@:await assertAtom(({ "created" : 1 }), tbl2.indexCreate("foo"));
		@:await assertAtom(({ "created" : 1 }), tbl2.indexCreate("bar", { "multi" : true }));
		@:await assertAtom(([true, true] : Array<Dynamic>), tbl2.indexStatus().map(function(x:Expr):Expr return x["progress"] < 1));
		@:await assertAtom((([true, true] : Array<Dynamic>)), tbl2.indexWait()["ready"]);
		@:await assertAtom(bag(([false, false] : Array<Dynamic>)), tbl2.indexWait()["geo"]);
		@:await assertAtom(bag(([false, true] : Array<Dynamic>)), tbl2.indexWait()["multi"]);
		@:await assertAtom((([false, false] : Array<Dynamic>)), tbl2.indexWait()["outdated"]);
		@:await assertAtom(({ "created" : 1 }), tbl2.indexCreate("quux"));
		@:await assertAtom(true, tbl2.indexStatus("quux").do_(function(x:Expr):Expr return (x[0]["index"] == "quux") & (x[0]["progress"] < 1)));
		@:await assertAtom((([{ "index" : "quux", "ready" : true }] : Array<Dynamic>)), tbl2.indexWait("quux").pluck("index", "ready"));
		@:await assertAtom(("PTYPE<BINARY>"), tbl2.indexWait("quux").nth(0).getField("function").typeOf());
		@:await dropTables(_tables);
		return Noise;
	}
}