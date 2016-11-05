package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestLogic extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", r.expr(r.expr("a")["b"]).default_(2));
		};
		return Noise;
	}
}