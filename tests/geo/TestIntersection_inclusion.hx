package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestIntersection_inclusion extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.point(1.5, 1.5)));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.point(2.5, 2.5)));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.5, 1.5)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.05, 1.05)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.point(2, 2)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.point(2, 1.5)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.line([1.5, 1.5], [2, 2])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.line([1.5, 1.5], [2, 1.5])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.1, 1.1)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.point(1.5, 1.1)));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.line([2, 2], [3, 3])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.line([2, 1.5], [3, 3])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.line([1.5, 1.5], [3, 3])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.polygon([1.5, 1.5], [2.5, 1.5], [2.5, 2.5], [1.5, 2.5])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).intersects(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.polygon([2, 1.1], [3, 1.1], [3, 1.9], [2, 1.9])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).intersects(r.polygon([2, 2], [3, 2], [3, 3], [2, 3])));
			@:await assertAtom(false, r.point(1, 1).intersects(r.point(1.5, 1.5)));
			@:await assertAtom(true, r.point(1, 1).intersects(r.point(1, 1)));
			@:await assertAtom(true, r.line([1, 1], [2, 1]).intersects(r.point(1, 1)));
			@:await assertAtom(true, r.line([1, 1], [1, 2]).intersects(r.point(1, 1.8)));
			@:await assertAtom(true, r.line([1, 0], [2, 0]).intersects(r.point(1.8, 0)));
			@:await assertAtom(false, r.line([1, 1], [2, 1]).intersects(r.point(1.5, 1.5)));
			@:await assertAtom(true, r.line([1, 1], [2, 1]).intersects(r.line([2, 1], [3, 1])));
			@:await assertAtom(2, r.expr([r.point(1, 0), r.point(3, 0), r.point(2, 0)]).intersects(r.line([0, 0], [2, 0])).count());
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.point(1.5, 1.5)));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.point(2.5, 2.5)));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.5, 1.5)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.05, 1.05)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.point(2, 2)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.point(2, 1.5)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.line([1.5, 1.5], [2, 2])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.line([1.5, 1.5], [2, 1.5])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.1, 1.1)));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.point(1.5, 1.1)));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.line([2, 2], [3, 3])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.line([2, 1.5], [2, 2])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.line([2, 1], [2, 2])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.line([1.5, 1.5], [3, 3])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.polygon([1, 1], [2, 1], [2, 2], [1, 2])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
			@:await assertAtom(true, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.polygon([1.5, 1.5], [2, 1.5], [2, 2], [1.5, 2])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.polygon([1.5, 1.5], [2.5, 1.5], [2.5, 2.5], [1.5, 2.5])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.polygon([1.2, 1.2], [1.8, 1.2], [1.8, 1.8], [1.2, 1.8])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).polygonSub(r.polygon([1.1, 1.1], [1.9, 1.1], [1.9, 1.9], [1.1, 1.9])).includes(r.polygon([1.1, 1.1], [2, 1.1], [2, 2], [1.1, 2])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.polygon([2, 1.1], [3, 1.1], [3, 1.9], [2, 1.9])));
			@:await assertAtom(false, r.polygon([1, 1], [2, 1], [2, 2], [1, 2]).includes(r.polygon([2, 2], [3, 2], [3, 3], [2, 3])));
			@:await assertAtom(1, r.expr([r.polygon([0, 0], [1, 1], [1, 0]), r.polygon([0, 1], [1, 2], [1, 1])]).includes(r.point(0, 0)).count());
			@:await assertError("ReqlQueryLogicError", "Expected geometry of type `Polygon` but found `Point`.", r.point(0, 0).includes(r.point(0, 0)));
			@:await assertError("ReqlQueryLogicError", "Expected geometry of type `Polygon` but found `LineString`.", r.line([0, 0], [0, 1]).includes(r.point(0, 0)));
		};
		return Noise;
	}
}