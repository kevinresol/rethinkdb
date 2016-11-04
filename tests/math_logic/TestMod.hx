package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestMod extends TestBase {
	override function test() {
		assertAtom(1, r.expr(10) % 3);
		assertAtom(1, 10 % r.expr(3));
		assertAtom(1, r.expr(10).mod(3));
		assertAtom(-1, r.expr(-10) % -3);
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(4) % "a");
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") % 1);
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("a") % "b");
	}
}