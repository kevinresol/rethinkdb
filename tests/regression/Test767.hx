package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test767 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertErrorRegex("ValueError", "Out of range float values are not JSON compliant.*", r.expr(float("NaN")));
			@:await assertErrorRegex("ValueError", "Out of range float values are not JSON compliant.*", r.expr(float("Infinity")));
		};
		return Noise;
	}
}