package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test831 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(({ "first_error" : "Expected type OBJECT but found BOOL.", "skipped" : 0, "deleted" : 0, "unchanged" : 0, "errors" : 2, "replaced" : 0, "inserted" : 0 }), tbl.insert(([true, true] : Array<Dynamic>)));
		@:await dropTables(_tables);
		return Noise;
	}
}