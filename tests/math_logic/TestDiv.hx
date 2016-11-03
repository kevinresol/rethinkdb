package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestDiv extends TestBase {
	override function test() {
		assertAtom(0.5, r.expr(-1) / -2);
		assertAtom(4.9 / 0.7, r.expr(4.9) / 0.7);
		assertAtom(1.0 / 120, r.expr(1).div(2, 3, 4, 5));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") / 0.8);
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1) / "a");
	}
}