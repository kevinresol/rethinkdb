package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestMul extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(2, r.expr(1) * 2);
		@:await assertAtom(2, 1 * r.expr(2));
		@:await assertAtom(2, r.expr(1).mul(2));
		@:await assertAtom(1, r.expr(-1) * -1);
		@:await assertAtom(6.75, r.expr(1.5) * 4.5);
		@:await assertAtom(([1, 2, 3, 1, 2, 3, 1, 2, 3] : Array<Dynamic>), r.expr(([1, 2, 3] : Array<Dynamic>)) * 3);
		@:await assertAtom(120, r.expr(1).mul(2, 3, 4, 5));
		@:await assertAtom(([1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3] : Array<Dynamic>), r.expr(2).mul(([1, 2, 3] : Array<Dynamic>), 2));
		@:await assertAtom(([1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3] : Array<Dynamic>), r.expr(([1, 2, 3] : Array<Dynamic>)).mul(2, 2));
		@:await assertAtom(([1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3] : Array<Dynamic>), r.expr(2).mul(2, ([1, 2, 3] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([0] : Array<Dynamic>)), r.expr("a") * 0.8);
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([1] : Array<Dynamic>)), r.expr(1) * "a");
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([0] : Array<Dynamic>)), r.expr("b") * "a");
		@:await assertError(err("ReqlQueryLogicError", "Number not an integer: 1.5", ([0] : Array<Dynamic>)), r.expr(([] : Array<Dynamic>)) * 1.5);
		return Noise;
	}
}