package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test2767 extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom({ "created" : 1 }, tbl.indexCreate("foo", function(x) return (x["a"] + [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10]).count()));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 1, "a" : [1, 2, 3, 4, 5] }));
		@:await assertAtom([{ "id" : 1, "a" : [1, 2, 3, 4, 5] }], tbl.coerceTo("array"));
		@:await assertAtom([{ "id" : 1, "a" : [1, 2, 3, 4, 5] }], tbl.getAll(15, { "index" : "foo" }).coerceTo("array"));
		@:await assertAtom([{ "id" : 1, "a" : [1, 2, 3, 4, 5] }], tbl.getAll(15, { "index" : "foo" }).coerceTo("array"));
		@:await dropTables(_tables);
		return Noise;
	}
}