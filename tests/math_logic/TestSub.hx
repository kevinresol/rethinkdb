package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestSub extends TestBase {
	override function test() {
		assertAtom(-2, r.expr(-1) - 1);
		assertAtom(-6.75, r.expr(1.75) - 8.5);
		assertAtom(-13, r.expr(1).sub(2, 4));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a").sub(0.8));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1).sub("a"));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("b").sub("a"));
	}
}