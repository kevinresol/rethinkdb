package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test5241 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		var dtbl = r.db("rethinkdb").table("_debug_scratch");
		@:await dropTables(_tables);
		return Noise;
	}
}