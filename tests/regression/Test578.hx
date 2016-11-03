package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test578 extends TestBase {
	override function test() {
		assertAtom(err_regex("ReqlOpFailedError", "Index `578` already exists on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", []), tbl.indexCreate("578", function(rec) return 1));
		assertAtom(err_regex("ReqlOpFailedError", "Index `578` does not exist on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", []), tbl.indexDrop("578"));
	}
}