package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestLogic extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(false, r.expr(true).not());
		@:await assertAtom(true, r.expr(false).not());
		@:await assertAtom(true, r.and(true, true, true, true, true));
		@:await assertAtom(false, r.and(true, true, true, false, true));
		@:await assertAtom(false, r.and(true, false, true, false, true));
		@:await assertAtom(false, r.or(false, false, false, false, false));
		@:await assertAtom(true, r.or(false, false, false, true, false));
		@:await assertAtom(true, r.or(false, true, false, true, false));
		@:await assertError("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", r.expr(r.expr("a")["b"]).default_(2));
		return Noise;
	}
}