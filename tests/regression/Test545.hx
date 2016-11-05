package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test545 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(1, tbl.reduce(r.js("(function(x,y){return 1;})")));
		@:await assertAtom(({ "id" : 3 }), tbl.reduce(r.js("(function(x,y){return {id:x[\"id\"] + y[\"id\"]};})")));
		@:await dropTables(_tables);
		return Noise;
	}
}