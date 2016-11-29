package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test469 extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("d469"));
		@:await assertAtom(partial({ "tables_created" : 1 }), r.db("d469").tableCreate("t469"));
		@:await assertAtom({ "created" : 1 }, r.db("d469").table("t469").indexCreate("x"));
		@:await assertAtom(([{ "ready" : true, "index" : "x" }] : Array<Dynamic>), r.db("d469").table("t469").indexWait("x").pluck("index", "ready"));
		@:await assertAtom({ "type" : "MINVAL" }, r.minval.info());
		@:await assertAtom({ "type" : "MAXVAL" }, r.maxval.info());
		@:await assertAtom({ "type" : "NULL" }, r.expr(null).info());
		@:await assertAtom({ "type" : "BOOL", "value" : "true" }, r.expr(true).info());
		@:await assertAtom({ "type" : "NUMBER", "value" : "1" }, r.expr(1).info());
		@:await assertAtom({ "type" : "STRING", "value" : ("\"1\"") }, r.expr("1").info());
		@:await assertAtom({ "type" : "ARRAY", "value" : "[\n\t1\n]" }, r.expr(([1] : Array<Dynamic>)).info());
		@:await assertAtom({ "type" : "OBJECT", "value" : "{\n\t\"a\":\t1\n}" }, r.expr({ "a" : 1 }).info());
		@:await assertAtom(partial({ "type" : "DB", "name" : "d469" }), r.db("d469").info());
		@:await assertAtom({ "type" : "TABLE", "name" : "t469", "id" : uuid(), "db" : { "type" : "DB", "name" : "d469", "id" : uuid() }, "primary_key" : "id", "indexes" : (["x"] : Array<Dynamic>), "doc_count_estimates" : ([0] : Array<Dynamic>) }, r.db("d469").table("t469").info());
		@:await assertAtom({ "type" : "SELECTION<STREAM>", "table" : { "type" : "TABLE", "name" : "t469", "id" : uuid(), "db" : { "type" : "DB", "name" : "d469", "id" : uuid() }, "primary_key" : "id", "indexes" : (["x"] : Array<Dynamic>), "doc_count_estimates" : ([0] : Array<Dynamic>) } }, r.db("d469").table("t469").filter(function(x:Expr):Expr return true).info());
		@:await assertAtom({ "type" : "STREAM" }, r.db("d469").table("t469").map(function(x:Expr):Expr return 1).info());
		@:await assertAtom({ "index" : "id", "left_bound" : 0, "left_bound_type" : "closed", "right_bound" : 1, "right_bound_type" : "open", "sorting" : "UNORDERED", "table" : { "db" : { "id" : uuid(), "name" : "d469", "type" : "DB" }, "doc_count_estimates" : ([0] : Array<Dynamic>), "id" : uuid(), "indexes" : (["x"] : Array<Dynamic>), "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(0, 1).info());
		@:await assertAtom({ "index" : "a", "left_bound" : 0, "left_bound_type" : "closed", "right_bound" : 1, "right_bound_type" : "open", "sorting" : "UNORDERED", "table" : { "db" : { "id" : uuid(), "name" : "d469", "type" : "DB" }, "doc_count_estimates" : ([0] : Array<Dynamic>), "id" : uuid(), "indexes" : (["x"] : Array<Dynamic>), "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(0, 1, { "index" : "a" }).info());
		@:await assertAtom({ "index" : "a", "left_bound" : 0, "left_bound_type" : "closed", "right_bound" : 1, "right_bound_type" : "open", "sorting" : "ASCENDING", "table" : { "db" : { "id" : uuid(), "name" : "d469", "type" : "DB" }, "doc_count_estimates" : ([0] : Array<Dynamic>), "id" : uuid(), "indexes" : (["x"] : Array<Dynamic>), "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").orderBy({ "index" : "a" }).between(0, 1, { "index" : "a" }).info());
		@:await assertAtom({ "index" : "id", "left_bound_type" : "unbounded", "right_bound_type" : "unbounded", "sorting" : "UNORDERED", "table" : { "db" : { "id" : uuid(), "name" : "d469", "type" : "DB" }, "doc_count_estimates" : ([0] : Array<Dynamic>), "id" : uuid(), "indexes" : (["x"] : Array<Dynamic>), "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(r.minval, r.maxval).info());
		@:await assertAtom({ "index" : "id", "left_bound_type" : "unachievable", "right_bound_type" : "unachievable", "sorting" : "UNORDERED", "table" : { "db" : { "id" : uuid(), "name" : "d469", "type" : "DB" }, "doc_count_estimates" : ([0] : Array<Dynamic>), "id" : uuid(), "indexes" : (["x"] : Array<Dynamic>), "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(r.maxval, r.minval).info());
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("d469"));
		return Noise;
	}
}