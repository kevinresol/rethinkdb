package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test2052 extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(1, r.expr(1));
		return Noise;
	}
}