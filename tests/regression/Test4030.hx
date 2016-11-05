package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test4030 extends TestBase {
	@:async
	override function test() {
		{
			var data = [{ "id" : 1 }, { "id" : 2 }, { "id" : 3 }, { "id" : 4 }, { "id" : 5 }, { "id" : 6 }];
			var changes = [{ "id" : 7 }, { "id" : 8 }, { "id" : 9 }, { "id" : 10 }];
			@:await assertPartial({ "errors" : 0, "inserted" : 6 }, tbl.insert(data));
			@:await assertAtom(6, tbl.count());
			@:await assertBag(data * 2, tbl.union(tbl));
			@:await assertBag(data * 2, r.union(tbl, tbl));
		};
		return Noise;
	}
}