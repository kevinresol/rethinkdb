package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class TestDiv extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(2, r.expr(4) / 2);
			@:await assertAtom(2, 4 / r.expr(2));
			@:await assertAtom(2, r.expr(4).div(2));
			@:await assertAtom(0.5, r.expr(-1) / -2);
			@:await assertAtom("4.9 / 0.7", r.expr(4.9) / 0.7);
			@:await assertAtom("1.0/120", r.expr(1).div(2, 3, 4, 5));
			@:await assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(1) / 0);
			@:await assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(2.0) / 0);
			@:await assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(3) / 0.0);
			@:await assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(4.0) / 0.0);
			@:await assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(0) / 0);
			@:await assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(0.0) / 0.0);
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") / 0.8);
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1) / "a");
		};
		return Noise;
	}
}