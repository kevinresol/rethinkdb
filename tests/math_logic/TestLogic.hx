package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestLogic extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", r.expr(r.expr("a")["b"]).default_(2));
	}
}