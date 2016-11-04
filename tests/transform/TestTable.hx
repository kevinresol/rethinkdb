package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestTable extends TestBase {
	override function test() {
		assertAtom({ "k1" : "v1", "k2" : "v2" }, tbl.map(r.row["a"]).coerceTo("object"));
		assertAtom("SELECTION<STREAM>", tbl.limit(1).typeOf());
		assertAtom("ARRAY", tbl.limit(1).coerceTo("array").typeOf());
	}
}