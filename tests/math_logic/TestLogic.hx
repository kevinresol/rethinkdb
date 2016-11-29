package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestLogic extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(true, r.expr(true) & true);
		@:await assertAtom(true, true & r.expr(true));
		@:await assertAtom(true, r.and(true, true));
		@:await assertAtom(true, r.expr(true).and(true));
		@:await assertAtom(false, r.expr(true) & false);
		@:await assertAtom(false, r.expr(false) & false);
		@:await assertAtom(false, true & r.expr(false));
		@:await assertAtom(false, false & r.expr(false));
		@:await assertAtom(false, r.and(true, false));
		@:await assertAtom(false, r.and(false, false));
		@:await assertAtom(false, r.expr(true).and(false));
		@:await assertAtom(false, r.expr(false).and(false));
		@:await assertAtom(true, r.or(true, true));
		@:await assertAtom(true, r.or(true, false));
		@:await assertAtom(true, r.expr(true).or(true));
		@:await assertAtom(true, r.expr(true).or(false));
		@:await assertAtom(false, r.and(false, false));
		@:await assertAtom(false, r.expr(false).and(false));
		@:await assertAtom(false, r.not(true));
		@:await assertAtom(true, r.not(false));
		@:await assertAtom(false, r.expr(true).not());
		@:await assertAtom(true, r.expr(false).not());
		@:await assertAtom(true, r.and(true, true, true, true, true));
		@:await assertAtom(false, r.and(true, true, true, false, true));
		@:await assertAtom(false, r.and(true, false, true, false, true));
		@:await assertAtom(false, r.or(false, false, false, false, false));
		@:await assertAtom(true, r.or(false, false, false, true, false));
		@:await assertAtom(true, r.or(false, true, false, true, false));
		@:await assertError(err("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", ([] : Array<Dynamic>)), r.expr(r.expr("a")["b"]).default_(2));
		@:await assertAtom(false, r.expr(r.and(true, false) == r.or(false, true)));
		@:await assertAtom(false, r.expr(r.and(true, false) >= r.or(false, true)));
		@:await assertAtom(true, r.expr(1) & true);
		return Noise;
	}
}