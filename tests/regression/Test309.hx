package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test309 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertBag([{ "id" : 0 }, { "id" : 1 }, 2, 3, 4], t.union([2, 3, 4]));
			@:await assertBag([{ "id" : 0 }, { "id" : 1 }, 2, 3, 4], r.expr([2, 3, 4]).union(t));
		};
		return Noise;
	}
}