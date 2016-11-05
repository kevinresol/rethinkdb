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
		@:await assertAtom(([{ "ready" : true }]), tbl.indexWait().pluck("ready"));
		@:await assertAtom(({ "inserted" : 2 }), tbl.insert([{ "id" : 1, "key" : ["a", "b"] }, { "id" : 2, "key" : ["a\u0000Sb"] }]).pluck("inserted"));
		@:await assertAtom(([{ "id" : 2 }]), tbl.getAll(["a\u0000Sb"], { "index" : "key" }).pluck("id"));
		@:await assertAtom(([{ "id" : 1 }]), tbl.getAll(["a", "b"], { "index" : "key" }).pluck("id"));
		@:await dropTables(_tables);
		return Noise;
	}
}