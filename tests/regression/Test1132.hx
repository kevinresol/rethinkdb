package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1132 extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "Duplicate key \"a\" in JSON.", r.json("{\"a\":1,\"a\":2}"));
	}
}