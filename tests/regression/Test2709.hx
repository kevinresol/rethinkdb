package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test2709 extends TestBase {
	@:async
	override function test() {
		{
			var _tables = ["tbl"];
			@:await createTables(_tables);
			var tbl = r.db("test").table("tbl");
			@:await assertAtom(999, tbl.map(function(thing) return "key").count());
			@:await assertAtom(999, tbl.map(function(thing) return "key").count());
			@:await dropTables(_tables);
		};
		return Noise;
	}
}