package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestTable extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom({ "k1" : "v1", "k2" : "v2" }, tbl.map(r.row["a"]).coerceTo("object"));
			@:await assertAtom("SELECTION<STREAM>", tbl.limit(1).typeOf());
			@:await assertAtom("ARRAY", tbl.limit(1).coerceTo("array").typeOf());
		};
		return Noise;
	}
}