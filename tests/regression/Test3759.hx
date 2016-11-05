package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test3759 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom([1], r.db("rethinkdb").table("jobs").map(function() return 1));
		@:await assertAtom(null, r.db("rethinkdb").table("jobs").map(function() return 1));
		@:await assertAtom(null, r.db("rethinkdb").table("jobs").map(function() return 1));
		@:await assertAtom([1], r.db("rethinkdb").table("jobs").map(function() return 1));
		@:await dropTables(_tables);
		return Noise;
	}
}