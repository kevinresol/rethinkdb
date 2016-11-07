package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test568 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		tbl.insert({ "name" : "Jim Brown" });
		@:await assertError(err("ReqlQueryLogicError", "Cannot convert STRING to SEQUENCE", []), tbl.concatMap(function(rec:Expr):Expr return rec["name"]));
		@:await dropTables(_tables);
		return Noise;
	}
}