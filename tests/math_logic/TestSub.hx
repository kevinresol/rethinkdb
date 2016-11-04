package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestSub extends TestBase {
	override function test() {
		assertAtom(0, r.expr(1) - 1);
		assertAtom(0, 1 - r.expr(1));
		assertAtom(0, r.expr(1).sub(1));
		assertAtom(-2, r.expr(-1) - 1);
		assertAtom(-6.75, r.expr(1.75) - 8.5);
		assertAtom(-13, r.expr(1).sub(2, 3, 4, 5));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a").sub(0.8));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1).sub("a"));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("b").sub("a"));
	}
}