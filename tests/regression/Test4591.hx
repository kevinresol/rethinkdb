package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test4591 extends TestBase {
	@:async
	override function test() {
		@:await assertError(err("ReqlQueryLogicError", "r.args is not supported in an order_by or union command yet."), r.expr(([{ "x" : 2 }, { "x" : 1 }] : Array<Dynamic>)).orderBy(r.args((["x", "y"] : Array<Dynamic>))));
		return Noise;
	}
}