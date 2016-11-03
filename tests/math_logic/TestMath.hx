package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestMath extends TestBase {
	override function test() {
		assertAtom(1, (((4 + 2 * (r.expr(26) % 18)) / 5) - 3));
	}
}