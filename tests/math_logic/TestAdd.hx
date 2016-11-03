package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestAdd extends TestBase {
	override function test() {
		assertAtom(2, r.add(1, 1));
		assertAtom(0, r.expr(-1) + 1);
		assertAtom(10.25, r.expr(1.75) + 8.5);
		assertAtom(abcdef, r.expr("abc") + "def");
		assertAtom([1, 3, 5, 7], r.expr([1]) + [3] + [4] + [6, 8]);
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr(1) + "a");
		assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", r.expr("a") + 1);
		assertError("ReqlQueryLogicError", "Expected type ARRAY but found NUMBER.", r.expr([]) + 1);
	}
}