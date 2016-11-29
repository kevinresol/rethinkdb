package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestIdxcopy extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(partial({ "created" : 1 }), tbl.indexCreate("a"));
		tbl.indexWait("a");
		var feed = tbl.orderBy({ "index" : "a" }).limit(10).changes({ "squash" : 2 });
		@:await assertAtom(partial({ "inserted" : 12, "errors" : 0 }), tbl.insert(r.range(0, 12).map({ "id" : r.row, "a" : 5 })));
		@:await assertAtom(partial({ "deleted" : 3, "errors" : 0 }), tbl.getAll(1, 8, 9, { "index" : "id" }).delete());
		wait(2);
		@:await assertAtom(bag(([{ "new_val" : { "a" : 5, "id" : 0 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 2 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 3 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 4 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 5 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 6 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 7 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 10 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 11 }, "old_val" : nil }] : Array<Dynamic>)), fetch(feed));
		@:await dropTables(_tables);
		return Noise;
	}
}