package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test309 extends TestBase {
	@:async
	override function test() {
		var _tables = ["t"];
		@:await createTables(_tables);
		var t = r.db("test").table("t");
		t.insert(([{ "id" : 0 }, { "id" : 1 }] : Array<Dynamic>));
		@:await assertAtom(bag(([{ "id" : 0 }, { "id" : 1 }, 2, 3, 4] : Array<Dynamic>)), t.union(([2, 3, 4] : Array<Dynamic>)));
		@:await assertAtom(bag(([{ "id" : 0 }, { "id" : 1 }, 2, 3, 4] : Array<Dynamic>)), r.expr(([2, 3, 4] : Array<Dynamic>)).union(t));
		@:await dropTables(_tables);
		return Noise;
	}
}