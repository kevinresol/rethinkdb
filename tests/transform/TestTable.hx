package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestTable extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		tbl.insert(([{ "a" : (["k1", "v1"] : Array<Dynamic>) }, { "a" : (["k2", "v2"] : Array<Dynamic>) }] : Array<Dynamic>));
		@:await assertAtom({ "k1" : "v1", "k2" : "v2" }, tbl.map(r.row["a"]).coerceTo("object"));
		@:await assertAtom("SELECTION<STREAM>", tbl.limit(1).typeOf());
		@:await assertAtom("ARRAY", tbl.limit(1).coerceTo("array").typeOf());
		@:await dropTables(_tables);
		return Noise;
	}
}