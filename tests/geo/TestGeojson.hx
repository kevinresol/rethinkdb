package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestGeojson extends TestBase {
	override function test() {
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point" }, r.geojson({ "coordinates" : [0, 0], "type" : "Point" }));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }, r.geojson({ "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }, r.geojson({ "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", r.geojson({ "coordinates" : [[], 0], "type" : "Point" }));
		assertError("ReqlQueryLogicError", "Expected type ARRAY but found BOOL.", r.geojson({ "coordinates" : true, "type" : "Point" }));
		assertError("ReqlNonExistenceError", "No attribute `coordinates` in object:", r.geojson({ "type" : "Point" }));
		assertError("ReqlNonExistenceError", "No attribute `type` in object:", r.geojson({ "coordinates" : [0, 0] }));
		assertError("ReqlQueryLogicError", "Unrecognized GeoJSON type `foo`.", r.geojson({ "coordinates" : [0, 0], "type" : "foo" }));
		assertError("ReqlQueryLogicError", "Unrecognized field `foo` found in geometry object.", r.geojson({ "coordinates" : [0, 0], "type" : "Point", "foo" : "wrong" }));
		assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point", "crs" : null }, r.geojson({ "coordinates" : [0, 0], "type" : "Point", "crs" : null }));
		assertError("ReqlQueryLogicError", "GeoJSON type `MultiPoint` is not supported.", r.geojson({ "coordinates" : [0, 0], "type" : "MultiPoint" }));
	}
}