package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestPrimitives extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "Radius must be smaller than a quarter of the circumference along the minor axis of the reference ellipsoid.  Got 14000000m, but must be smaller than 9985163.1855612862855m.", r.circle([0, 0], 14000000, { "num_vertices" : 3 }));
		assertError("ReqlQueryLogicError", "Radius must be smaller than a quarter of the circumference along the minor axis of the reference ellipsoid.  Got 2m, but must be smaller than 1.570796326794896558m.", r.circle([0, 0], 2, { "num_vertices" : 3, "geo_system" : "unit_sphere" }));
	}
}