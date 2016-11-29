package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestPrimitives extends TestBase {
	@:async
	override function test() {
		@:await assertError(err("ReqlQueryLogicError", "Radius must be smaller than a quarter of the circumference along the minor axis of the reference ellipsoid.  Got 14000000m, but must be smaller than 9985163.1855612862855m.", ([0] : Array<Dynamic>)), r.circle(([0, 0] : Array<Dynamic>), 14000000, { "num_vertices" : 3 }));
		@:await assertError(err("ReqlQueryLogicError", "Radius must be smaller than a quarter of the circumference along the minor axis of the reference ellipsoid.  Got 2m, but must be smaller than 1.570796326794896558m.", ([0] : Array<Dynamic>)), r.circle(([0, 0] : Array<Dynamic>), 2, { "num_vertices" : 3, "geo_system" : "unit_sphere" }));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([([([0, -5.729577951308232] : Array<Dynamic>), ([-4.966092947444857, 2.861205754495701] : Array<Dynamic>), ([4.966092947444857, 2.861205754495701] : Array<Dynamic>), ([0, -5.729577951308232] : Array<Dynamic>)] : Array<Dynamic>)] : Array<Dynamic>), "type" : "Polygon" }), r.circle(([0, 0] : Array<Dynamic>), 0.1, { "num_vertices" : 3, "geo_system" : "unit_sphere" }));
		return Noise;
	}
}