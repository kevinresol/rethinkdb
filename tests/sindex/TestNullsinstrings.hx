package sindex;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestNullsinstrings extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(({ "created" : 1 }), tbl.indexCreate("key"));
		@:await assertAtom(([{ "ready" : true }] : Array<Dynamic>), tbl.indexWait().pluck("ready"));
		@:await assertAtom(({ "inserted" : 2 }), tbl.insert(([{ "id" : 1, "key" : (["a", "b"] : Array<Dynamic>) }, { "id" : 2, "key" : (["a\u0000Sb"] : Array<Dynamic>) }] : Array<Dynamic>)).pluck("inserted"));
		@:await assertAtom(([{ "id" : 2 }] : Array<Dynamic>), tbl.getAll((["a\u0000Sb"] : Array<Dynamic>), { "index" : "key" }).pluck("id"));
		@:await assertAtom(([{ "id" : 1 }] : Array<Dynamic>), tbl.getAll((["a", "b"] : Array<Dynamic>), { "index" : "key" }).pluck("id"));
		@:await dropTables(_tables);
		return Noise;
	}
}