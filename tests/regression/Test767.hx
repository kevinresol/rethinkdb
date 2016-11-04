package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test767 extends TestBase {
	override function test() {
		assertErrorRegex("ValueError", "Out of range float values are not JSON compliant.*", r.expr(float("NaN")));
		assertErrorRegex("ValueError", "Out of range float values are not JSON compliant.*", r.expr(float("Infinity")));
	}
}