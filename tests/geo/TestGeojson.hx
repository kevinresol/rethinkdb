package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestGeojson extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point" }), r.geojson({ "coordinates" : [0, 0], "type" : "Point" }));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }), r.geojson({ "coordinates" : [[0, 0], [0, 1]], "type" : "LineString" }));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }), r.geojson({ "coordinates" : [[[0, 0], [0, 1], [1, 0], [0, 0]]], "type" : "Polygon" }));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", [0]), r.geojson({ "coordinates" : [[], 0], "type" : "Point" }));
		@:await assertError(err("ReqlQueryLogicError", "Expected type ARRAY but found BOOL.", [0]), r.geojson({ "coordinates" : true, "type" : "Point" }));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `coordinates` in object:", [0]), r.geojson({ "type" : "Point" }));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `type` in object:", [0]), r.geojson({ "coordinates" : [0, 0] }));
		@:await assertError(err("ReqlQueryLogicError", "Unrecognized GeoJSON type `foo`.", [0]), r.geojson({ "coordinates" : [0, 0], "type" : "foo" }));
		@:await assertError(err("ReqlQueryLogicError", "Unrecognized field `foo` found in geometry object.", [0]), r.geojson({ "coordinates" : [0, 0], "type" : "Point", "foo" : "wrong" }));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : [0, 0], "type" : "Point", "crs" : null }), r.geojson({ "coordinates" : [0, 0], "type" : "Point", "crs" : null }));
		@:await assertError(err("ReqlQueryLogicError", "GeoJSON type `MultiPoint` is not supported.", [0]), r.geojson({ "coordinates" : [0, 0], "type" : "MultiPoint" }));
		return Noise;
	}
}