package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test1132 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "Duplicate key \"a\" in JSON.", r.json("{\"a\":1,\"a\":2}"));
		};
		return Noise;
	}
}