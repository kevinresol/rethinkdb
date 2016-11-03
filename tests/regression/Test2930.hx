package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2930 extends TestBase {
	override function test() {
		assertError("ReqlResourceLimitError", "Array over size limit `500`.  To raise the number of allowed elements, modify the `array_limit` option to `.run` (not available in the Data Explorer), or use an index.", tbl.coerceTo("array"));
		assertError("ReqlResourceLimitError", "Grouped data over size limit `500`.  Try putting a reduction (like `.reduce` or `.count`) on the end.", tbl.group("mod").coerceTo("array"));
		assertError("ReqlResourceLimitError", "Grouped data over size limit `500`.  Try putting a reduction (like `.reduce` or `.count`) on the end.", tbl.group("foo").coerceTo("array"));
	}
}