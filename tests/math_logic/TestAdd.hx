package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestAdd extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(2, r.add(1, 1));
			@:await assertAtom(2, r.expr(1) + 1);
			@:await assertAtom(2, 1 + r.expr(1));
			@:await assertAtom(2, r.expr(1).add(1));
			@:await assertAtom(0, r.expr(-1) + 1);
			@:await assertAtom(10.25, r.expr(1.75) + 8.5);
			@:await assertAtom("", r.expr("") + "");
			@:await assertAtom("abcdef", r.expr("abc") + "def");
			@:await assertAtom([1, 2, 3, 4, 5, 6, 7, 8], r.expr([1, 2]) + [3] + [4, 5] + [6, 7, 8]);
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1) + "a");
			@:await assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", r.expr("a") + 1);
			@:await assertError("ReqlQueryLogicError", "Expected type ARRAY but found NUMBER.", r.expr([]) + 1);
		};
		return Noise;
	}
}