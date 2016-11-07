package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test370 extends TestBase {
	@:async
	override function test() {
		var d = r.db("test");
		@:await assertAtom((["rethinkdb", "test"]), r.dbList().map(r.row));
		@:await assertAtom((["t370"]), d.tableList().map(r.row));
		r.db("test").tableDrop("t370");
		return Noise;
	}
}