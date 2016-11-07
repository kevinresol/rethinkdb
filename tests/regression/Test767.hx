package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test767 extends TestBase {
	@:async
	override function test() {
		@:await assertError(err_regex("ValueError", "Out of range float values are not JSON compliant.*"), r.expr(float("NaN")));
		@:await assertError(err_regex("ValueError", "Out of range float values are not JSON compliant.*"), r.expr(float("Infinity")));
		return Noise;
	}
}