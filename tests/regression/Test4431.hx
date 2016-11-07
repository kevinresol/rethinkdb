package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test4431 extends TestBase {
	@:async
	override function test() {
		@:await assertError(err("ReqlQueryLogicError", "The `use_outdated` optarg is no longer supported.  Use the `read_mode` optarg instead."), r.table("test"));
		@:await assertError(err("ReqlQueryLogicError", "The `use_outdated` optarg is no longer supported.  Use the `read_mode` optarg instead."), r.table("test", { "use_outdated" : true }));
		return Noise;
	}
}