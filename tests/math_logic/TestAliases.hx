package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestAliases extends TestBase {
	override function test() {
		assertAtom(1, r.expr(0).add(1));
		assertAtom(1, r.add(0, 1));
		assertAtom(1, r.expr(2).sub(1));
		assertAtom(1, r.sub(2, 1));
		assertAtom(1, r.expr(2).div(2));
		assertAtom(1, r.div(2, 2));
		assertAtom(1, r.expr(1).mul(1));
		assertAtom(1, r.mul(1, 1));
		assertAtom(1, r.expr(1).mod(2));
		assertAtom(1, r.mod(1, 2));
		assertAtom(true, r.expr(1).eq(1));
		assertAtom(true, r.expr(1).ne(2));
		assertAtom(true, r.expr(1).lt(2));
		assertAtom(true, r.expr(1).gt(0));
		assertAtom(true, r.expr(1).le(1));
		assertAtom(true, r.expr(1).ge(1));
		assertAtom(true, r.eq(1, 1));
		assertAtom(true, r.ne(1, 2));
		assertAtom(true, r.lt(1, 2));
		assertAtom(true, r.gt(1, 0));
		assertAtom(true, r.le(1, 1));
		assertAtom(true, r.ge(1, 1));
	}
}