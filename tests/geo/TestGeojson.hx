package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestGeojson extends TestBase {
	@:async
	override function test() {
		@:await assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point" }, r.geojson({ "coordinates" : [0, 0], "type" : "Point" }));
		@:await assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }, r.geojson({ "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }));
		@:await assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }, r.geojson({ "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", r.geojson({ "coordinates" : [[], 0], "type" : "Point" }));
		@:await assertError("ReqlQueryLogicError", "Expected type ARRAY but found BOOL.", r.geojson({ "coordinates" : true, "type" : "Point" }));
		@:await assertError("ReqlNonExistenceError", "No attribute `coordinates` in object:", r.geojson({ "type" : "Point" }));
		@:await assertError("ReqlNonExistenceError", "No attribute `type` in object:", r.geojson({ "coordinates" : [0, 0] }));
		@:await assertError("ReqlQueryLogicError", "Unrecognized GeoJSON type `foo`.", r.geojson({ "coordinates" : [0, 0], "type" : "foo" }));
		@:await assertError("ReqlQueryLogicError", "Unrecognized field `foo` found in geometry object.", r.geojson({ "coordinates" : [0, 0], "type" : "Point", "foo" : "wrong" }));
		@:await assertAtom({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point", "crs" : null }, r.geojson({ "coordinates" : [0, 0], "type" : "Point", "crs" : null }));
		@:await assertError("ReqlQueryLogicError", "GeoJSON type `MultiPoint` is not supported.", r.geojson({ "coordinates" : [0, 0], "type" : "MultiPoint" }));
		return Noise;
	}
}