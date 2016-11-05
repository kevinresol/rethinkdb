package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestIdxcopy extends TestBase {
	@:async
	override function test() {
		{
			@:await assertPartial({ "created" : 1 }, tbl.indexCreate("a"));
			@:await assertPartial({ "inserted" : 12, "errors" : 0 }, tbl.insert(r.range(0, 12).map({ "id" : r.row, "a" : 5 })));
			@:await assertPartial({ "deleted" : 3, "errors" : 0 }, tbl.getAll(1, 8, 9, { "index" : "id" }).delete());
			@:await assertBag([{ "new_val" : { "a" : 5, "id" : 0 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 2 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 3 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 4 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 5 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 6 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 7 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 10 }, "old_val" : nil }, { "new_val" : { "a" : 5, "id" : 11 }, "old_val" : nil }], fetch(feed));
		};
		return Noise;
	}
}