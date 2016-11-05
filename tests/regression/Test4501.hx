package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test4501 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertErrorRegex("ReqlOpFailedError", "Index `missing` was not found on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", tbl.indexWait("missing"));
		@:await dropTables(_tables);
		return Noise;
	}
}