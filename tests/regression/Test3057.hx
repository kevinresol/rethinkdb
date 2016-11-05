package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test3057 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(false, r.polygon([0, 0], [0, 10], [10, 10], [10, 0]).polygonSub(r.polygon([0, 0], [0, 10], [10, 10], [10, 0])).intersects(r.point(0, 0)));
			@:await assertAtom(false, r.polygon([0, 0], [0, 10], [10, 10], [10, 0]).polygonSub(r.polygon([0, 0], [0, 10], [10, 10], [10, 0])).intersects(r.polygon([0, 0], [0, 10], [10, 10], [10, 0])));
			@:await assertAtom(false, r.polygon([0, 0], [0, 10], [10, 10], [10, 0]).polygonSub(r.polygon([0, 0], [0, 10], [10, 10], [10, 0])).intersects(r.line([0, 0], [0, 10])));
			@:await assertAtom(false, r.polygon([0, 0], [0, 10], [10, 10], [10, 0]).intersects(r.polygon([0, 0], [0, 10], [10, 10], [10, 0]).polygonSub(r.polygon([0, 0], [0, 10], [10, 10], [10, 0]))));
		};
		return Noise;
	}
}