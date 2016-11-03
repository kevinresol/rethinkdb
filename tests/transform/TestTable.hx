package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestTable extends TestBase {
	override function test() {
		assertAtom(null, tbl.insert([{ a : ["k1", "v1"] }, { a : ["k2", "v2"] }]));
	}
}