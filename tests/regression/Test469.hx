package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test469 extends TestBase {
	override function test() {
		assertAtom("partial({\'dbs_created\':1})", r.dbCreate("d469"));
		assertAtom("partial({\'tables_created\':1})", r.db("d469").tableCreate("t469"));
		assertAtom({ "created" : 1 }, r.db("d469").table("t469").indexCreate("x"));
		assertAtom([{ "ready" : true, "index" : "x" }], r.db("d469").table("t469").indexWait("x").pluck("index", "ready"));
		assertAtom({ "type" : "MINVAL" }, r.minval.info());
		assertAtom({ "type" : "MAXVAL" }, r.maxval.info());
		assertAtom({ "type" : "NULL" }, r.expr(null).info());
		assertAtom({ "type" : "NUMBER", "value" : "1" }, r.expr(1).info());
		assertAtom({ "type" : "STRING", "value" : "(\'\"1\"\')" }, r.expr("1").info());
		assertAtom({ "type" : "ARRAY", "value" : "[\n\t1\n]" }, r.expr([1]).info());
		assertAtom({ "type" : "OBJECT", "value" : "{\n\t\"a\":\t1\n}" }, r.expr({ "a" : 1 }).info());
		assertAtom("partial({\'type\':\'DB\',\'name\':\'d469\'})", r.db("d469").info());
		assertAtom({ "type" : "TABLE", "name" : "t469", "id" : "uuid()", "db" : { "type" : "DB", "name" : "d469", "id" : "uuid()" }, "primary_key" : "id", "indexes" : ["x"], "doc_count_estimates" : [0] }, r.db("d469").table("t469").info());
		assertAtom({ "type" : "STREAM" }, r.db("d469").table("t469").map(function(x) return 1).info());
		assertAtom({ "index" : "id", "left_bound" : 0, "left_bound_type" : "closed", "right_bound" : 1, "right_bound_type" : "open", "sorting" : "UNORDERED", "table" : { "db" : { "id" : "uuid()", "name" : "d469", "type" : "DB" }, "doc_count_estimates" : [0], "id" : "uuid()", "indexes" : ["x"], "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(0, 1).info());
		assertAtom({ "index" : "a", "left_bound" : 0, "left_bound_type" : "closed", "right_bound" : 1, "right_bound_type" : "open", "sorting" : "UNORDERED", "table" : { "db" : { "id" : "uuid()", "name" : "d469", "type" : "DB" }, "doc_count_estimates" : [0], "id" : "uuid()", "indexes" : ["x"], "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(0, 1, { "index" : "a" }).info());
		assertAtom({ "index" : "a", "left_bound" : 0, "left_bound_type" : "closed", "right_bound" : 1, "right_bound_type" : "open", "sorting" : "ASCENDING", "table" : { "db" : { "id" : "uuid()", "name" : "d469", "type" : "DB" }, "doc_count_estimates" : [0], "id" : "uuid()", "indexes" : ["x"], "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").orderBy({ "index" : "a" }).between(0, 1, { "index" : "a" }).info());
		assertAtom({ "index" : "id", "left_bound_type" : "unbounded", "right_bound_type" : "unbounded", "sorting" : "UNORDERED", "table" : { "db" : { "id" : "uuid()", "name" : "d469", "type" : "DB" }, "doc_count_estimates" : [0], "id" : "uuid()", "indexes" : ["x"], "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(r.minval, r.maxval).info());
		assertAtom({ "index" : "id", "left_bound_type" : "unachievable", "right_bound_type" : "unachievable", "sorting" : "UNORDERED", "table" : { "db" : { "id" : "uuid()", "name" : "d469", "type" : "DB" }, "doc_count_estimates" : [0], "id" : "uuid()", "indexes" : ["x"], "name" : "t469", "primary_key" : "id", "type" : "TABLE" }, "type" : "TABLE_SLICE" }, r.db("d469").table("t469").between(r.maxval, r.minval).info());
		assertAtom("partial({\'dbs_dropped\':1})", r.dbDrop("d469"));
	}
}