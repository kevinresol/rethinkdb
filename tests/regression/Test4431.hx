package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test4431 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "The `use_outdated` optarg is no longer supported.  Use the `read_mode` optarg instead.", r.table("test"));
		};
		return Noise;
	}
}