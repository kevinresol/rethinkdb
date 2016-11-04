package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4501 extends TestBase {
	override function test() {
		assertErrorRegex("ReqlOpFailedError", "Index `missing` was not found on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", tbl.indexWait("missing"));
	}
}