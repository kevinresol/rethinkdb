package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test2696 extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(4, 4));
		@:await assertAtom(([] : Array<Dynamic>), r.expr(([] : Array<Dynamic>)).deleteAt(0, 0));
		return Noise;
	}
}