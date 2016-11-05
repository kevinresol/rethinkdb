package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestOperations extends TestBase {
	@:async
	override function test() {
		@:await assertAtom("89011.26253835332", r.distance(r.point(-122, 37), r.point(-123, 37)).coerceTo("STRING"));
		@:await assertAtom("110968.30443995494", r.distance(r.point(-122, 37), r.point(-122, 36)).coerceTo("STRING"));
		@:await assertAtom(true, r.distance(r.point(-122, 37), r.point(-122, 36)).eq(r.distance(r.point(-122, 36), r.point(-122, 37))));
		@:await assertAtom("89011.26253835332", r.point(-122, 37).distance(r.point(-123, 37)).coerceTo("STRING"));
		@:await assertAtom(true, someDist.eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "m" })));
		var someDist = r.distance(r.point(-122, 37), r.point(-123, 37));
		@:await assertAtom(true, someDist.mul(1.0 / 1000.0).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "km" })));
		@:await assertAtom(true, someDist.mul(1.0 / 1609.344).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "mi" })));
		@:await assertAtom(true, someDist.mul(1.0 / 0.3048).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "ft" })));
		@:await assertAtom(true, someDist.mul(1.0 / 1852.0).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "nm" })));
		@:await assertAtom(true, someDist.eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "geo_system" : "WGS84" })));
		@:await assertAtom(true, someDist.div(10).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "geo_system" : { "a" : 637813.7, "f" : (1.0 / 298.257223563) } })));
		@:await assertAtom("0.01393875509649327", r.distance(r.point(-122, 37), r.point(-123, 37), { "geo_system" : "unit_sphere" }).coerceTo("STRING"));
		@:await assertAtom("0", r.distance(r.point(0, 0), r.point(0, 0)).coerceTo("STRING"));
		@:await assertAtom("40007862.917250897", r.distance(r.point(0, 0), r.point(180, 0)).mul(2).coerceTo("STRING"));
		@:await assertAtom("40007862.917250897", r.distance(r.point(0, -90), r.point(0, 90)).mul(2).coerceTo("STRING"));
		@:await assertAtom("0", r.distance(r.point(0, 0), r.line([0, 0], [0, 1])).coerceTo("STRING"));
		@:await assertAtom("0", r.distance(r.line([0, 0], [0, 1]), r.point(0, 0)).coerceTo("STRING"));
		@:await assertAtom(true, r.distance(r.point(0, 0), r.line([0.1, 0], [1, 0])).eq(r.distance(r.point(0, 0), r.point(0.1, 0))));
		@:await assertAtom("492471.4990055255", r.distance(r.point(0, 0), r.line([5, -1], [4, 2])).coerceTo("STRING"));
		@:await assertAtom("492471.4990055255", r.distance(r.point(0, 0), r.polygon([5, -1], [4, 2], [10, 10])).coerceTo("STRING"));
		@:await assertAtom("0", r.distance(r.point(0, 0), r.polygon([0, -1], [0, 1], [10, 10])).coerceTo("STRING"));
		@:await assertAtom("0", r.distance(r.point(0.5, 0.5), r.polygon([0, -1], [0, 1], [10, 10])).coerceTo("STRING"));
		@:await assertAtom(false, r.circle([0, 0], 1, { "fill" : false }).eq(r.circle([0, 0], 1, { "fill" : true })));
		@:await assertAtom(true, r.circle([0, 0], 1, { "fill" : false }).fill().eq(r.circle([0, 0], 1, { "fill" : true })));
		@:await assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]], [[0.1, 0.1], [0.9, 0.1], [0.9, 0.9], [0.1, 0.9], [0.1, 0.1]]], "type" : "Polygon" }, r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0.1, 0.1], [0.9, 0.1], [0.9, 0.9], [0.1, 0.9])));
		@:await assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0.1, 0.9], [0.9, 0.0], [0.9, 0.9], [0.1, 0.9])));
		@:await assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, 0], [2, 0], [2, 2], [0, 2])));
		@:await assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, -2], [1, -2], [-1, 1], [0, -1])));
		@:await assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, -1], [1, -1], [1, 0], [0, 0])));
		@:await assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0.1, -1], [0.9, -1], [0.9, 0.5], [0.1, 0.5])));
		@:await assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]], [[0, 0], [0.1, 0.9], [0.9, 0.9], [0.9, 0.1], [0, 0]]], "type" : "Polygon" }, r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, 0], [0.1, 0.9], [0.9, 0.9], [0.9, 0.1])));
		@:await assertError("ReqlQueryLogicError", "Expected a Polygon with only an outer shell.  This one has holes.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, 0], [0.1, 0.9], [0.9, 0.9], [0.9, 0.1]).polygonSub(r.polygon([0.2, 0.2], [0.5, 0.8], [0.8, 0.2]))));
		@:await assertError("ReqlQueryLogicError", "Expected a Polygon but found a LineString.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.line([0, 0], [0.9, 0.1], [0.9, 0.9], [0.1, 0.9])));
		return Noise;
	}
}