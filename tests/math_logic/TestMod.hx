package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestMod extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(1, r.expr(10) % 3);
			@:await assertAtom(1, 10 % r.expr(3));
			@:await assertAtom(1, r.expr(10).mod(3));
			@:await assertAtom(-1, r.expr(-10) % -3);
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(4) % "a");
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") % 1);
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") % "b");
		};
		return Noise;
	}
}