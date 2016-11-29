package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test453 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "inserted" : 2 }), tbl.insert(([{ "a" : 1 }, { "a" : 2 }] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected type DATUM but found TABLE:", ([0] : Array<Dynamic>)), tbl.map(function(x:Expr):Expr return tbl));
		@:await assertAtom(2, tbl.map(function(x:Expr):Expr return tbl.coerceTo("array")).count());
		@:await dropTables(_tables);
		return Noise;
	}
}