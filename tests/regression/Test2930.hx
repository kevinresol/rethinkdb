package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test2930 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(({ "inserted" : 999 }), tbl.insert([for (i in range(1, 1000)) { "id" : i, "mod" : i % 5, "foo" : 5 }]).pluck("first_error", "inserted"));
		@:await assertError("ReqlResourceLimitError", "Array over size limit `500`.  To raise the number of allowed elements, modify the `array_limit` option to `.run` (not available in the Data Explorer), or use an index.", tbl.coerceTo("array"));
		@:await assertError("ReqlResourceLimitError", "Grouped data over size limit `500`.  Try putting a reduction (like `.reduce` or `.count`) on the end.", tbl.group("mod").coerceTo("array"));
		@:await assertError("ReqlResourceLimitError", "Grouped data over size limit `500`.  Try putting a reduction (like `.reduce` or `.count`) on the end.", tbl.group("foo").coerceTo("array"));
		@:await dropTables(_tables);
		return Noise;
	}
}