package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test3637 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "inserted" : 2 }), tbl.insert([{ "id" : 0.0, "value" : "abc" }, { "id" : [1, -0.0], "value" : "def" }]));
		@:await assertAtom({ "id" : 0.0, "value" : "abc" }, tbl.get(0.0));
		@:await assertAtom({ "id" : 0.0, "value" : "abc" }, tbl.get(-0.0));
		@:await assertAtom({ "id" : [1, -0.0], "value" : "def" }, tbl.get([1, 0.0]));
		@:await assertAtom({ "id" : [1, -0.0], "value" : "def" }, tbl.get([1, -0.0]));
		@:await assertAtom("{\"id\":0}", tbl.get(0.0).pluck("id").toJsonString());
		@:await assertAtom("{\"id\":0}", tbl.get(-0.0).pluck("id").toJsonString());
		@:await assertAtom("{\"id\":[1,-0.0]}", tbl.get([1, 0.0]).pluck("id").toJsonString());
		@:await assertAtom("{\"id\":[1,-0.0]}", tbl.get([1, -0.0]).pluck("id").toJsonString());
		@:await assertAtom(partial({ "errors" : 1 }), tbl.insert({ "id" : 0.0 }));
		@:await assertAtom(partial({ "errors" : 1 }), tbl.insert({ "id" : [1, 0.0] }));
		@:await assertAtom(partial({ "errors" : 1 }), tbl.insert({ "id" : -0.0 }));
		@:await assertAtom(partial({ "errors" : 1 }), tbl.insert({ "id" : [1, -0.0] }));
		@:await dropTables(_tables);
		return Noise;
	}
}