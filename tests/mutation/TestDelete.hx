package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDelete extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 100 }), tbl.insert(([for (i in xrange(100)) { "id" : i }] : Array<Dynamic>)));
		@:await assertAtom(100, tbl.count());
		@:await assertAtom(({ "deleted" : 1, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }), tbl.get(12).delete());
		@:await assertError(err("ReqlQueryLogicError", "Durability option `wrong` unrecognized (options are \"hard\" and \"soft\").", ([0] : Array<Dynamic>)), tbl.skip(50).delete({ "durability" : "wrong" }));
		@:await assertAtom(({ "deleted" : 49, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }), tbl.skip(50).delete({ "durability" : "soft" }));
		@:await assertAtom(({ "deleted" : 50, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }), tbl.delete({ "durability" : "hard" }));
		@:await assertError(err("ReqlQueryLogicError", "Expected type SELECTION but found DATUM:", ([0] : Array<Dynamic>)), r.expr(([1, 2] : Array<Dynamic>)).delete());
		@:await dropTables(_tables);
		return Noise;
	}
}