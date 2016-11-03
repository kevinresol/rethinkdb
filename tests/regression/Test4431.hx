package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4431 extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "The `use_outdated` optarg is no longer supported.  Use the `read_mode` optarg instead.", r.table("test"));
	}
}