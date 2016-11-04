package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestOperations extends TestBase {
	override function test() {
		assertAtom("89011.26253835332", r.distance(r.point(-122, 37), r.point(-123, 37)).coerceTo("STRING"));
		assertAtom("110968.30443995494", r.distance(r.point(-122, 37), r.point(-122, 36)).coerceTo("STRING"));
		assertAtom(true, r.distance(r.point(-122, 37), r.point(-122, 36)).eq(r.distance(r.point(-122, 36), r.point(-122, 37))));
		assertAtom("89011.26253835332", r.point(-122, 37).distance(r.point(-123, 37)).coerceTo("STRING"));
		assertAtom(true, someDist.eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "m" })));
		var someDist = r.distance(r.point(-122, 37), r.point(-123, 37));
		assertAtom(true, someDist.mul(1.0 / 1000.0).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "km" })));
		assertAtom(true, someDist.mul(1.0 / 1609.344).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "mi" })));
		assertAtom(true, someDist.mul(1.0 / 0.3048).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "ft" })));
		assertAtom(true, someDist.mul(1.0 / 1852.0).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "unit" : "nm" })));
		assertAtom(true, someDist.eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "geo_system" : "WGS84" })));
		assertAtom(true, someDist.div(10).eq(r.distance(r.point(-122, 37), r.point(-123, 37), { "geo_system" : { "a" : 637813.7, "f" : (1.0 / 298.257223563) } })));
		assertAtom("0.01393875509649327", r.distance(r.point(-122, 37), r.point(-123, 37), { "geo_system" : "unit_sphere" }).coerceTo("STRING"));
		assertAtom("0", r.distance(r.point(0, 0), r.point(0, 0)).coerceTo("STRING"));
		assertAtom("40007862.917250897", r.distance(r.point(0, 0), r.point(180, 0)).mul(2).coerceTo("STRING"));
		assertAtom("40007862.917250897", r.distance(r.point(0, -90), r.point(0, 90)).mul(2).coerceTo("STRING"));
		assertAtom("0", r.distance(r.point(0, 0), r.line([0, 0], [0, 1])).coerceTo("STRING"));
		assertAtom("0", r.distance(r.line([0, 0], [0, 1]), r.point(0, 0)).coerceTo("STRING"));
		assertAtom(true, r.distance(r.point(0, 0), r.line([0.1, 0], [1, 0])).eq(r.distance(r.point(0, 0), r.point(0.1, 0))));
		assertAtom("492471.4990055255", r.distance(r.point(0, 0), r.line([5, -1], [4, 2])).coerceTo("STRING"));
		assertAtom("492471.4990055255", r.distance(r.point(0, 0), r.polygon([5, -1], [4, 2], [10, 10])).coerceTo("STRING"));
		assertAtom("0", r.distance(r.point(0, 0), r.polygon([0, -1], [0, 1], [10, 10])).coerceTo("STRING"));
		assertAtom("0", r.distance(r.point(0.5, 0.5), r.polygon([0, -1], [0, 1], [10, 10])).coerceTo("STRING"));
		assertAtom(false, r.circle([0, 0], 1, { "fill" : false }).eq(r.circle([0, 0], 1, { "fill" : true })));
		assertAtom(true, r.circle([0, 0], 1, { "fill" : false }).fill().eq(r.circle([0, 0], 1, { "fill" : true })));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]], [[0.1, 0.1], [0.9, 0.1], [0.9, 0.9], [0.1, 0.9], [0.1, 0.1]]], "type" : "Polygon" }, r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0.1, 0.1], [0.9, 0.1], [0.9, 0.9], [0.1, 0.9])));
		assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0.1, 0.9], [0.9, 0.0], [0.9, 0.9], [0.1, 0.9])));
		assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, 0], [2, 0], [2, 2], [0, 2])));
		assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, -2], [1, -2], [-1, 1], [0, -1])));
		assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, -1], [1, -1], [1, 0], [0, 0])));
		assertError("ReqlQueryLogicError", "The second argument to `polygon_sub` is not contained in the first one.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0.1, -1], [0.9, -1], [0.9, 0.5], [0.1, 0.5])));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]], [[0, 0], [0.1, 0.9], [0.9, 0.9], [0.9, 0.1], [0, 0]]], "type" : "Polygon" }, r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, 0], [0.1, 0.9], [0.9, 0.9], [0.9, 0.1])));
		assertError("ReqlQueryLogicError", "Expected a Polygon with only an outer shell.  This one has holes.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.polygon([0, 0], [0.1, 0.9], [0.9, 0.9], [0.9, 0.1]).polygonSub(r.polygon([0.2, 0.2], [0.5, 0.8], [0.8, 0.2]))));
		assertError("ReqlQueryLogicError", "Expected a Polygon but found a LineString.", r.polygon([0, 0], [1, 0], [1, 1], [0, 1]).polygonSub(r.line([0, 0], [0.9, 0.1], [0.9, 0.9], [0.1, 0.9])));
	}
}