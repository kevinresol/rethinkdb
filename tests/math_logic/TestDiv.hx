package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDiv extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(2, r.expr(4) / 2);
		@:await assertAtom(2, 4 / r.expr(2));
		@:await assertAtom(2, r.expr(4).div(2));
		@:await assertAtom(0.5, r.expr(-1) / -2);
		@:await assertAtom(4.9 / 0.7, r.expr(4.9) / 0.7);
		@:await assertAtom(1.0 / 120, r.expr(1).div(2, 3, 4, 5));
		@:await assertError(err("ReqlQueryLogicError", "Cannot divide by zero.", ([1] : Array<Dynamic>)), r.expr(1) / 0);
		@:await assertError(err("ReqlQueryLogicError", "Cannot divide by zero.", ([1] : Array<Dynamic>)), r.expr(2.0) / 0);
		@:await assertError(err("ReqlQueryLogicError", "Cannot divide by zero.", ([1] : Array<Dynamic>)), r.expr(3) / 0.0);
		@:await assertError(err("ReqlQueryLogicError", "Cannot divide by zero.", ([1] : Array<Dynamic>)), r.expr(4.0) / 0.0);
		@:await assertError(err("ReqlQueryLogicError", "Cannot divide by zero.", ([1] : Array<Dynamic>)), r.expr(0) / 0);
		@:await assertError(err("ReqlQueryLogicError", "Cannot divide by zero.", ([1] : Array<Dynamic>)), r.expr(0.0) / 0.0);
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([0] : Array<Dynamic>)), r.expr("a") / 0.8);
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([1] : Array<Dynamic>)), r.expr(1) / "a");
		return Noise;
	}
}