package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class TestPolymorphism extends TestBase {
	@:async
	override function test() {
		{
			var obj = r.expr({ "id" : 0, "a" : 0 });
			@:await assertAtom({ "id" : 0, "c" : 1, "a" : 0 }, tbl.merge({ "c" : 1 }).nth(0));
			@:await assertAtom({ "id" : 0, "c" : 1, "a" : 0 }, obj.merge({ "c" : 1 }));
			@:await assertAtom({ "id" : 0 }, tbl.without("a").nth(0));
			@:await assertAtom({ "id" : 0 }, obj.without("a"));
			@:await assertAtom({ "a" : 0 }, tbl.pluck("a").nth(0));
			@:await assertAtom({ "a" : 0 }, obj.pluck("a"));
		};
		return Noise;
	}
}