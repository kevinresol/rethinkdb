package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test579 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		tbl.insert({ "name" : "Jim Brown" });
		@:await assertError(err("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic.", ([] : Array<Dynamic>)), tbl.indexCreate("579", function(rec:Expr):Expr return r.js("1")));
		@:await assertError(err("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic.", ([] : Array<Dynamic>)), tbl.indexCreate("579", function(rec:Expr):Expr return tbl.get(0)));
		@:await dropTables(_tables);
		return Noise;
	}
}