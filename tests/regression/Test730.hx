package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test730 extends TestBase {
	@:async
	override function test() {
		return Noise;
	}
}