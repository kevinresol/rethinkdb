package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2052 extends TestBase {
	override function test() {
		assertAtom(1, r.expr(1));
		assertError("ReqlCompileError", "Unrecognized global optional argument `obviously_bogus`.", r.expr(1));
	}
}