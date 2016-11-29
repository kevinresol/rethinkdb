package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestConstructors extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([0, 0] : Array<Dynamic>), "type" : "Point" }), r.point(0, 0));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([0, -90] : Array<Dynamic>), "type" : "Point" }), r.point(0, -90));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([0, 90] : Array<Dynamic>), "type" : "Point" }), r.point(0, 90));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([-180, 0] : Array<Dynamic>), "type" : "Point" }), r.point(-180, 0));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([180, 0] : Array<Dynamic>), "type" : "Point" }), r.point(180, 0));
		@:await assertError(err("ReqlQueryLogicError", "Latitude must be between -90 and 90.  Got -91.", ([0] : Array<Dynamic>)), r.point(0, -91));
		@:await assertError(err("ReqlQueryLogicError", "Latitude must be between -90 and 90.  Got 91.", ([0] : Array<Dynamic>)), r.point(0, 91));
		@:await assertError(err("ReqlQueryLogicError", "Longitude must be between -180 and 180.  Got -181.", ([0] : Array<Dynamic>)), r.point(-181, 0));
		@:await assertError(err("ReqlQueryLogicError", "Longitude must be between -180 and 180.  Got 181.", ([0] : Array<Dynamic>)), r.point(181, 0));
		@:await assertError(err("ReqlQueryLogicError", "Invalid LineString.  Are there antipodal or duplicate vertices?", ([0] : Array<Dynamic>)), r.line(([0, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>)] : Array<Dynamic>), "type" : "LineString" }), r.line(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected point coordinate pair.  Got 1 element array instead of a 2 element one.", ([0] : Array<Dynamic>)), r.line(([0, 0] : Array<Dynamic>), ([1] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected point coordinate pair.  Got 3 element array instead of a 2 element one.", ([0] : Array<Dynamic>)), r.line(([0, 0] : Array<Dynamic>), ([1, 0, 0] : Array<Dynamic>)));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)] : Array<Dynamic>), "type" : "LineString" }), r.line(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)] : Array<Dynamic>), "type" : "LineString" }), r.line(r.point(0, 0), r.point(0, 1), r.point(0, 0)));
		@:await assertError(err("ReqlQueryLogicError", "Expected geometry of type `Point` but found `LineString`.", ([0] : Array<Dynamic>)), r.line(r.point(0, 0), r.point(1, 0), r.line(([0, 0] : Array<Dynamic>), ([1, 0] : Array<Dynamic>))));
		@:await assertError(err("ReqlQueryLogicError", "Invalid LinearRing.  Are there antipodal or duplicate vertices? Is it self-intersecting?", ([0] : Array<Dynamic>)), r.polygon(([0, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([([([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)] : Array<Dynamic>)] : Array<Dynamic>), "type" : "Polygon" }), r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>)));
		@:await assertAtom(({ "$reql_type$" : "GEOMETRY", "coordinates" : ([([([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)] : Array<Dynamic>)] : Array<Dynamic>), "type" : "Polygon" }), r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>), ([0, 0] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Invalid LinearRing.  Are there antipodal or duplicate vertices? Is it self-intersecting?", ([0] : Array<Dynamic>)), r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>), ([-1, 0.5] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected point coordinate pair.  Got 1 element array instead of a 2 element one.", ([0] : Array<Dynamic>)), r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([0] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected point coordinate pair.  Got 3 element array instead of a 2 element one.", ([0] : Array<Dynamic>)), r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([0, 1, 0] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected geometry of type `Point` but found `LineString`.", ([0] : Array<Dynamic>)), r.polygon(r.point(0, 0), r.point(0, 1), r.line(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>))));
		return Noise;
	}
}