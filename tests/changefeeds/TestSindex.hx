package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestSindex extends TestBase {
	@:async
	override function test() {
		{
			var _tables = ["tbl"];
			@:await createTables(_tables);
			var tbl = r.db("test").table("tbl");
			@:await dropTables(_tables);
		};
		return Noise;
	}
}