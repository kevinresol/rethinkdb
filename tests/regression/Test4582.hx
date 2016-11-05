package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test4582 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(0).replace(tbl.get(0)));
			@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(0).update(tbl.get(0)));
			@:await assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.replace(r.args([tbl.get(0)])));
		};
		return Noise;
	}
}