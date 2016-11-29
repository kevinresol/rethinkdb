package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestPolymorphism extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		var obj = r.expr({ "id" : 0, "a" : 0 });
		@:await assertAtom(({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 3 }), tbl.insert(([for (i in xrange(3)) { "id" : i, "a" : i }] : Array<Dynamic>)));
		@:await assertAtom(({ "id" : 0, "c" : 1, "a" : 0 }), tbl.merge({ "c" : 1 }).nth(0));
		@:await assertAtom(({ "id" : 0, "c" : 1, "a" : 0 }), obj.merge({ "c" : 1 }));
		@:await assertAtom(({ "id" : 0 }), tbl.without("a").nth(0));
		@:await assertAtom(({ "id" : 0 }), obj.without("a"));
		@:await assertAtom(({ "a" : 0 }), tbl.pluck("a").nth(0));
		@:await assertAtom(({ "a" : 0 }), obj.pluck("a"));
		@:await dropTables(_tables);
		return Noise;
	}
}