package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test3745 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "inserted" : 2 }), tbl.insert([{ "id" : 0, "a" : 5 }, { "id" : 1, "a" : 6 }]));
		@:await assertAtom(({ "a" : 11 }), tbl.reduce(function(x, y) return r.object("a", r.add(x["a"], y["a"]))));
		@:await assertError("ReqlQueryLogicError", "Cannot convert NUMBER to SEQUENCE", tbl.reduce(function(x, y) return r.expr(0)[0]));
		@:await dropTables(_tables);
		return Noise;
	}
}