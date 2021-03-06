package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestSub extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(0, r.expr(1) - 1);
		@:await assertAtom(0, 1 - r.expr(1));
		@:await assertAtom(0, r.expr(1).sub(1));
		@:await assertAtom(-2, r.expr(-1) - 1);
		@:await assertAtom(-6.75, r.expr(1.75) - 8.5);
		@:await assertAtom(-13, r.expr(1).sub(2, 3, 4, 5));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([0] : Array<Dynamic>)), r.expr("a").sub(0.8));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([1] : Array<Dynamic>)), r.expr(1).sub("a"));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([0] : Array<Dynamic>)), r.expr("b").sub("a"));
		return Noise;
	}
}