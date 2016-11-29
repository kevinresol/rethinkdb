package geo;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestIndexing extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		var rows = ([{ "id" : 0, "g" : r.point(10, 10), "m" : ([r.point(0, 0), r.point(1, 0), r.point(2, 0)] : Array<Dynamic>) }, { "id" : 1, "g" : r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>)) }, { "id" : 2, "g" : r.line(([0.000002, -1] : Array<Dynamic>), ([-0.000001, 1] : Array<Dynamic>)) }] : Array<Dynamic>);
		@:await assertAtom(({ "deleted" : 0, "inserted" : 3, "skipped" : 0, "errors" : 0, "replaced" : 0, "unchanged" : 0 }), tbl.insert(rows));
		@:await assertAtom({ "created" : 1 }, tbl.indexCreate("g", { "geo" : true }));
		@:await assertAtom({ "created" : 1 }, tbl.indexCreate("m", { "geo" : true, "multi" : true }));
		@:await assertAtom({ "created" : 1 }, tbl.indexCreate("other"));
		@:await assertAtom({ "created" : 1 }, tbl.indexCreate("point_det", function(x:Expr):Expr return r.point(x, x)));
		tbl.indexWait();
		@:await assertError(err("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic."), tbl.indexCreate("point_det", function(x:Expr):Expr return r.line(x, x)));
		@:await assertError(err("ReqlQueryLogicError", "Index `other` is not a geospatial index.  get_intersecting can only be used with a geospatial index.", ([0] : Array<Dynamic>)), tbl.getIntersecting(r.point(0, 0), { "index" : "other" }).count());
		@:await assertError(err_regex("ReqlOpFailedError", "Index `missing` was not found on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", ([0] : Array<Dynamic>)), tbl.getIntersecting(r.point(0, 0), { "index" : "missing" }).count());
		@:await assertError(err("ReqlQueryLogicError", "get_intersecting requires an index argument.", ([0] : Array<Dynamic>)), tbl.getIntersecting(r.point(0, 0)).count());
		@:await assertError(err("ReqlQueryLogicError", "Index `g` is a geospatial index.  Only get_nearest and get_intersecting can use a geospatial index.", ([0] : Array<Dynamic>)), tbl.getAll(0, { "index" : "g" }).count());
		@:await assertError(err("ReqlQueryLogicError", "Index `g` is a geospatial index.  Only get_nearest and get_intersecting can use a geospatial index.", ([0] : Array<Dynamic>)), tbl.between(0, 1, { "index" : "g" }).count());
		@:await assertError(err("ReqlQueryLogicError", "Index `g` is a geospatial index.  Only get_nearest and get_intersecting can use a geospatial index.", ([0] : Array<Dynamic>)), tbl.orderBy({ "index" : "g" }).count());
		@:await assertError(err("AttributeError", "\'Between\' object has no attribute \'get_intersecting\'"), tbl.between(0, 1).getIntersecting(r.point(0, 0), { "index" : "g" }).count());
		@:await assertError(err("AttributeError", "\'GetAll\' object has no attribute \'get_intersecting\'"), tbl.getAll(0).getIntersecting(r.point(0, 0), { "index" : "g" }).count());
		@:await assertError(err("AttributeError", "\'OrderBy\' object has no attribute \'get_intersecting\'"), tbl.orderBy({ "index" : "id" }).getIntersecting(r.point(0, 0), { "index" : "g" }).count());
		@:await assertError(err("ReqlQueryLogicError", "get_intersecting cannot use the primary index.", ([0] : Array<Dynamic>)), tbl.getIntersecting(r.point(0, 0), { "index" : "id" }).count());
		@:await assertAtom(1, tbl.getIntersecting(r.point(0, 0), { "index" : "g" }).count());
		@:await assertAtom(1, tbl.getIntersecting(r.point(10, 10), { "index" : "g" }).count());
		@:await assertAtom(1, tbl.getIntersecting(r.point(0.5, 0.5), { "index" : "g" }).count());
		@:await assertAtom(0, tbl.getIntersecting(r.point(20, 20), { "index" : "g" }).count());
		@:await assertAtom(2, tbl.getIntersecting(r.polygon(([0, 0] : Array<Dynamic>), ([1, 0] : Array<Dynamic>), ([1, 1] : Array<Dynamic>), ([0, 1] : Array<Dynamic>)), { "index" : "g" }).count());
		@:await assertAtom(3, tbl.getIntersecting(r.line(([0, 0] : Array<Dynamic>), ([10, 10] : Array<Dynamic>)), { "index" : "g" }).count());
		@:await assertAtom(("SELECTION<STREAM>"), tbl.getIntersecting(r.point(0, 0), { "index" : "g" }).typeOf());
		@:await assertAtom(("SELECTION<STREAM>"), tbl.getIntersecting(r.point(0, 0), { "index" : "g" }).filter(true).typeOf());
		@:await assertAtom(("STREAM"), tbl.getIntersecting(r.point(0, 0), { "index" : "g" }).map(r.row).typeOf());
		@:await assertAtom(1, tbl.getIntersecting(r.point(0, 0), { "index" : "m" }).count());
		@:await assertAtom(1, tbl.getIntersecting(r.point(1, 0), { "index" : "m" }).count());
		@:await assertAtom(1, tbl.getIntersecting(r.point(2, 0), { "index" : "m" }).count());
		@:await assertAtom(0, tbl.getIntersecting(r.point(3, 0), { "index" : "m" }).count());
		@:await assertAtom(2, tbl.getIntersecting(r.polygon(([0, 0] : Array<Dynamic>), ([0, 1] : Array<Dynamic>), ([1, 1] : Array<Dynamic>), ([1, 0] : Array<Dynamic>)), { "index" : "m" }).count());
		@:await assertError(err("ReqlQueryLogicError", "Index `other` is not a geospatial index.  get_nearest can only be used with a geospatial index.", ([0] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "other" }));
		@:await assertError(err_regex("ReqlOpFailedError", "Index `missing` was not found on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", ([0] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "missing" }));
		@:await assertError(err("ReqlQueryLogicError", "get_nearest requires an index argument.", ([0] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0)));
		@:await assertError(err("AttributeError", "\'Between\' object has no attribute \'get_nearest\'"), tbl.between(0, 1).getNearest(r.point(0, 0), { "index" : "g" }).count());
		@:await assertError(err("AttributeError", "\'GetAll\' object has no attribute \'get_nearest\'"), tbl.getAll(0).getNearest(r.point(0, 0), { "index" : "g" }).count());
		@:await assertError(err("AttributeError", "\'OrderBy\' object has no attribute \'get_nearest\'"), tbl.orderBy({ "index" : "id" }).getNearest(r.point(0, 0), { "index" : "g" }).count());
		@:await assertError(err("ReqlQueryLogicError", "get_nearest cannot use the primary index.", ([0] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "id" }).count());
		@:await assertAtom((([{ "dist" : 0, "doc" : { "id" : 1 } }, { "dist" : 0.055659745396754216, "doc" : { "id" : 2 } }] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "g" }).pluck("dist", { "doc" : "id" }));
		@:await assertAtom((([{ "dist" : 0, "doc" : { "id" : 2 } }, { "dist" : 0.11130264976984369, "doc" : { "id" : 1 } }] : Array<Dynamic>)), tbl.getNearest(r.point(-0.000001, 1), { "index" : "g" }).pluck("dist", { "doc" : "id" }));
		@:await assertAtom((([{ "dist" : 0, "doc" : { "id" : 1 } }, { "dist" : 0.055659745396754216, "doc" : { "id" : 2 } }, { "dist" : 1565109.0992178896, "doc" : { "id" : 0 } }] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "g", "max_dist" : 1565110 }).pluck("dist", { "doc" : "id" }));
		@:await assertAtom((([{ "dist" : 0, "doc" : { "id" : 1 } }, { "dist" : 0.055659745396754216, "doc" : { "id" : 2 } }] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "g", "max_dist" : 1565110, "max_results" : 2 }).pluck("dist", { "doc" : "id" }));
		@:await assertError(err("ReqlQueryLogicError", "The distance has become too large for continuing the indexed nearest traversal.  Consider specifying a smaller `max_dist` parameter.  (Radius must be smaller than a quarter of the circumference along the minor axis of the reference ellipsoid.  Got 10968937.995244588703m, but must be smaller than 9985163.1855612862855m.)", ([0] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "g", "max_dist" : 10000000 }).pluck("dist", { "doc" : "id" }));
		@:await assertAtom((([{ "dist" : 0, "doc" : { "id" : 1 } }, { "dist" : 0.00005565974539675422, "doc" : { "id" : 2 } }, { "dist" : 1565.1090992178897, "doc" : { "id" : 0 } }] : Array<Dynamic>)), tbl.getNearest(r.point(0, 0), { "index" : "g", "max_dist" : 1566, "unit" : "km" }).pluck("dist", { "doc" : "id" }));
		@:await assertAtom(("ARRAY"), tbl.getNearest(r.point(0, 0), { "index" : "g" }).typeOf());
		@:await assertAtom(("ARRAY"), tbl.getNearest(r.point(0, 0), { "index" : "g" }).map(r.row).typeOf());
		@:await dropTables(_tables);
		return Noise;
	}
}