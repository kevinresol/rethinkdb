package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestIntersection_inclusion extends TestBase {
	override function test() {
		assertAtom(true, r.polygon([1], [2], [2], [1]).intersects(r.point(1.5, 1.5)));
		assertAtom(false, r.polygon([1], [2], [2], [1]).intersects(r.point(2.5, 2.5)));
		assertAtom(false, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.5, 1.5)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.05, 1.05)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).intersects(r.point(2)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).intersects(r.line([1.5, 1.5], [2])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.1, 1.1)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.5, 1.1)));
		assertAtom(false, r.polygon([1], [2], [2], [1]).intersects(r.line([2], [3])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).intersects(r.line([1.5, 1.5], [3])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).intersects(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).intersects(r.polygon([1.5, 1.5], [2.5, 1.5], [2.5, 2.5], [1.5, 2.5])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).intersects(r.polygon([2], [3], [3], [2])));
		assertAtom(false, r.point(1).intersects(r.point(1.5, 1.5)));
		assertAtom(true, r.point(1).intersects(r.point(1)));
		assertAtom(true, r.line([1], [2]).intersects(r.point(1)));
		assertAtom(true, r.line([1], [2]).intersects(r.point(1.8, 0)));
		assertAtom(false, r.line([1], [2]).intersects(r.point(1.5, 1.5)));
		assertAtom(true, r.line([1], [2]).intersects(r.line([2], [3])));
		assertAtom(2, r.expr([r.point(1, 0), r.point(3), r.point(2, 0)]).intersects(r.line([0], [2, 0])).count());
		assertAtom(true, r.polygon([1], [2], [2], [1]).includes(r.point(1.5, 1.5)));
		assertAtom(false, r.polygon([1], [2], [2], [1]).includes(r.point(2.5, 2.5)));
		assertAtom(false, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.5, 1.5)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.05, 1.05)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).includes(r.point(2)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).includes(r.line([1.5, 1.5], [2])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.1, 1.1)));
		assertAtom(true, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.5, 1.1)));
		assertAtom(false, r.polygon([1], [2], [2], [1]).includes(r.line([2], [3])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).includes(r.line([2], [2])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).includes(r.line([1.5, 1.5], [3])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).includes(r.polygon([1], [2], [2], [1])));
		assertAtom(true, r.polygon([1], [2], [2], [1]).includes(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).includes(r.polygon([1.5, 1.5], [2.5, 1.5], [2.5, 2.5], [1.5, 2.5])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
		assertAtom(false, r.polygon([1], [2], [2], [1]).includes(r.polygon([2], [3], [3], [2])));
		assertAtom(1, r.expr([r.polygon([0], [1], [1]), r.polygon([0], [1], [1])]).includes(r.point(0)).count());
		assertError("ReqlQueryLogicError", "Expected geometry of type `Polygon` but found `Point`.", r.point(0).includes(r.point(0)));
		assertError("ReqlQueryLogicError", "Expected geometry of type `Polygon` but found `LineString`.", r.line([0], [0]).includes(r.point(0)));
	}
}