package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestConstructors extends TestBase {
	override function test() {
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point" }, r.point(0, 0));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, -90], "type" : "Point" }, r.point(0, -90));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 90], "type" : "Point" }, r.point(0, 90));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [-180, 0], "type" : "Point" }, r.point(-180, 0));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [180, 0], "type" : "Point" }, r.point(180, 0));
		assertError("ReqlQueryLogicError", "Latitude must be between -90 and 90.  Got -91.", r.point(0, -91));
		assertError("ReqlQueryLogicError", "Latitude must be between -90 and 90.  Got 91.", r.point(0, 91));
		assertError("ReqlQueryLogicError", "Longitude must be between -180 and 180.  Got -181.", r.point(-181, 0));
		assertError("ReqlQueryLogicError", "Longitude must be between -180 and 180.  Got 181.", r.point(181, 0));
		assertError("ReqlCompileError", "Expected 2 or more arguments but found 0.", r.line());
		assertError("ReqlCompileError", "Expected 2 or more arguments but found 1.", r.line([0, 0]));
		assertError("ReqlQueryLogicError", "Invalid LineString.  Are there antipodal or duplicate vertices?", r.line([0, 0], [0, 0]));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }, r.line([0, 0], [0, 1]));
		assertError("ReqlQueryLogicError", "Expected point coordinate pair.  Got 1 element array instead of a 2 element one.", r.line([0, 0], [1]));
		assertError("ReqlQueryLogicError", "Expected point coordinate pair.  Got 3 element array instead of a 2 element one.", r.line([0, 0], [1, 0, 0]));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[0, 0], [0, 1], [0, 0]], "type" : "LineString" }, r.line([0, 0], [0, 1], [0, 0]));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[0, 0], [0, 1], [0, 0]], "type" : "LineString" }, r.line(r.point(0, 0), r.point(0, 1), r.point(0, 0)));
		assertError("ReqlQueryLogicError", "Expected geometry of type `Point` but found `LineString`.", r.line(r.point(0, 0), r.point(1, 0), r.line([0, 0], [1, 0])));
		assertError("ReqlCompileError", "Expected 3 or more arguments but found 0.", r.polygon());
		assertError("ReqlCompileError", "Expected 3 or more arguments but found 1.", r.polygon([0, 0]));
		assertError("ReqlCompileError", "Expected 3 or more arguments but found 2.", r.polygon([0, 0], [0, 0]));
		assertError("ReqlQueryLogicError", "Invalid LinearRing.  Are there antipodal or duplicate vertices? Is it self-intersecting?", r.polygon([0, 0], [0, 0], [0, 0], [0, 0]));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }, r.polygon([0, 0], [0, 1], [1, 0]));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }, r.polygon([0, 0], [0, 1], [1, 0], [0, 0]));
		assertError("ReqlQueryLogicError", "Invalid LinearRing.  Are there antipodal or duplicate vertices? Is it self-intersecting?", r.polygon([0, 0], [0, 1], [1, 0], [-1, 0.5]));
		assertError("ReqlQueryLogicError", "Expected point coordinate pair.  Got 1 element array instead of a 2 element one.", r.polygon([0, 0], [0, 1], [0]));
		assertError("ReqlQueryLogicError", "Expected point coordinate pair.  Got 3 element array instead of a 2 element one.", r.polygon([0, 0], [0, 1], [0, 1, 0]));
		assertError("ReqlQueryLogicError", "Expected geometry of type `Point` but found `LineString`.", r.polygon(r.point(0, 0), r.point(0, 1), r.line([0, 0], [0, 1])));
	}
}