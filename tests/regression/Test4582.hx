package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test4582 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertError(err("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?"), tbl.get(0).replace(tbl.get(0)));
		@:await assertError(err("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?"), tbl.get(0).update(tbl.get(0)));
		@:await assertError(err("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?"), tbl.replace(r.args(([tbl.get(0)] : Array<Dynamic>))));
		@:await dropTables(_tables);
		return Noise;
	}
}