package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test2696 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom([1, 2, 3, 4], r.expr([1, 2, 3, 4]).deleteAt(4, 4));
			@:await assertAtom([], r.expr([]).deleteAt(0, 0));
		};
		return Noise;
	}
}