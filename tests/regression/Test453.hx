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
		@:await assertPartial({ "inserted" : 2 }, tbl.insert([{ "a" : 1 }, { "a" : 2 }]));
		@:await assertError("ReqlQueryLogicError", "Expected type DATUM but found TABLE:", tbl.map(function(x) return tbl));
		@:await assertAtom(2, tbl.map(function(x) return tbl.coerceTo("array")).count());
		@:await dropTables(_tables);
		return Noise;
	}
}