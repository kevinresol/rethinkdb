package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestGeojson extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", r.geojson({ coordinates : [[], 0], type : "Point" }));
		assertError("ReqlQueryLogicError", "Expected type ARRAY but found BOOL.", r.geojson({ coordinates : true, type : "Point" }));
		assertError("ReqlNonExistenceError", "No attribute `coordinates` in object:", r.geojson({ type : "Point" }));
		assertError("ReqlNonExistenceError", "No attribute `type` in object:", r.geojson({ coordinates : [0, 0] }));
		assertError("ReqlQueryLogicError", "Unrecognized GeoJSON type `foo`.", r.geojson({ coordinates : [0, 0], type : "foo" }));
		assertError("ReqlQueryLogicError", "Unrecognized field `foo` found in geometry object.", r.geojson({ coordinates : [0, 0], type : "Point", foo : "wrong" }));
		assertError("ReqlQueryLogicError", "GeoJSON type `MultiPoint` is not supported.", r.geojson({ coordinates : [0, 0], type : "MultiPoint" }));
	}
}