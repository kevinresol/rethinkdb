package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4501 extends TestBase {
	override function test() {
		assertAtom(err_regex("ReqlOpFailedError", "Index `missing` was not found on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", [0]), tbl.indexWait("missing"));
	}
}