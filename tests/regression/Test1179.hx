package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test1179 extends TestBase {
	@:async
	override function test() {
		{
			var _tables = ["tbl"];
			@:await createTables(_tables);
			var tbl = r.db("test").table("tbl");
			@:await assertAtom(1, r.expr([1])[r.expr(0)]);
			@:await dropTables(_tables);
		};
		return Noise;
	}
}