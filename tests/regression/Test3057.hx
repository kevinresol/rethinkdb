package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test3057 extends TestBase {
	override function test() {
		assertAtom((false), r.polygon([0], [0], [10, 10], [10, 0]).polygonSub(r.polygon([0], [0], [10, 10], [10, 0])).intersects(r.point(0)));
		assertAtom((false), r.polygon([0], [0], [10, 10], [10, 0]).polygonSub(r.polygon([0], [0], [10, 10], [10, 0])).intersects(r.polygon([0], [0], [10, 10], [10, 0])));
		assertAtom((false), r.polygon([0], [0], [10, 10], [10, 0]).polygonSub(r.polygon([0], [0], [10, 10], [10, 0])).intersects(r.line([0], [0])));
		assertAtom((false), r.polygon([0], [0], [10, 10], [10, 0]).intersects(r.polygon([0], [0], [10, 10], [10, 0]).polygonSub(r.polygon([0], [0], [10, 10], [10, 0]))));
	}
}