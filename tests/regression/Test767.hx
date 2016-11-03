package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test767 extends TestBase {
	override function test() {
		assertAtom(err_regex("ValueError", "Out of range float values are not JSON compliant.*"), r.expr(float("NaN")));
		assertAtom(err_regex("ValueError", "Out of range float values are not JSON compliant.*"), r.expr(float("Infinity")));
	}
}