package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestDiv extends TestBase {
	override function test() {
		assertAtom(2, r.expr(4) / 2);
		assertAtom(2, 4 / r.expr(2));
		assertAtom(2, r.expr(4).div(2));
		assertAtom(0.5, r.expr(-1) / -2);
		assertAtom("4.9 / 0.7", r.expr(4.9) / 0.7);
		assertAtom("1.0/120", r.expr(1).div(2, 3, 4, 5));
		assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(1) / 0);
		assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(2.0) / 0);
		assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(3) / 0.0);
		assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(4.0) / 0.0);
		assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(0) / 0);
		assertError("ReqlQueryLogicError", "Cannot divide by zero.", r.expr(0.0) / 0.0);
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") / 0.8);
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1) / "a");
	}
}