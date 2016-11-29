package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDefault extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(1, r.expr(1).default_(2));
		@:await assertAtom(2, r.expr(null).default_(2));
		@:await assertAtom(2, r.expr({  })["b"].default_(2));
		@:await assertError(err("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", ([] : Array<Dynamic>)), r.expr(r.expr("a")["b"]).default_(2));
		@:await assertAtom(2, r.expr(([] : Array<Dynamic>)).reduce(function(a:Expr, b:Expr):Expr return a + b).default_(2));
		@:await assertAtom(2, r.expr(([] : Array<Dynamic>)).union(([] : Array<Dynamic>)).reduce(function(a:Expr, b:Expr):Expr return a + b).default_(2));
		@:await assertError(err("ReqlQueryLogicError", "Cannot convert STRING to SEQUENCE", ([] : Array<Dynamic>)), r.expr("a").reduce(function(a:Expr, b:Expr):Expr return a + b).default_(2));
		@:await assertAtom(2, (r.expr(null) + 5).default_(2));
		@:await assertAtom(2, (5 + r.expr(null)).default_(2));
		@:await assertAtom(2, (5 - r.expr(null)).default_(2));
		@:await assertAtom(2, (r.expr(null) - 5).default_(2));
		@:await assertError(err("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", ([] : Array<Dynamic>)), (r.expr("a") + 5).default_(2));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([] : Array<Dynamic>)), (5 + r.expr("a")).default_(2));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([] : Array<Dynamic>)), (r.expr("a") - 5).default_(2));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", ([] : Array<Dynamic>)), (5 - r.expr("a")).default_(2));
		@:await assertAtom(1, r.expr(1).default_(r.error()));
		@:await assertAtom((null), r.expr(null).default_(r.error()));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `b` in object:", ([] : Array<Dynamic>)), r.expr({  })["b"].default_(r.error()));
		@:await assertError(err("ReqlNonExistenceError", "Cannot reduce over an empty stream.", ([] : Array<Dynamic>)), r.expr(([] : Array<Dynamic>)).reduce(function(a:Expr, b:Expr):Expr return a + b).default_(r.error));
		@:await assertError(err("ReqlNonExistenceError", "Cannot reduce over an empty stream.", ([] : Array<Dynamic>)), r.expr(([] : Array<Dynamic>)).union(([] : Array<Dynamic>)).reduce(function(a:Expr, b:Expr):Expr return a + b).default_(r.error));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([] : Array<Dynamic>)), (r.expr(null) + 5).default_(r.error));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([] : Array<Dynamic>)), (5 + r.expr(null)).default_(r.error));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([] : Array<Dynamic>)), (5 - r.expr(null)).default_(r.error));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([] : Array<Dynamic>)), (r.expr(null) - 5).default_(r.error));
		@:await assertAtom(1, r.expr(1).default_(function(e:Expr):Expr return e));
		@:await assertAtom((null), r.expr(null).default_(function(e:Expr):Expr return e));
		@:await assertAtom("No attribute `b` in object:\n{}", r.expr({  })["b"].default_(function(e:Expr):Expr return e));
		@:await assertAtom(("Cannot reduce over an empty stream."), r.expr(([] : Array<Dynamic>)).reduce(function(a:Expr, b:Expr):Expr return a + b).default_(function(e:Expr):Expr return e));
		@:await assertAtom(("Cannot reduce over an empty stream."), r.expr(([] : Array<Dynamic>)).union(([] : Array<Dynamic>)).reduce(function(a:Expr, b:Expr):Expr return a + b).default_(function(e:Expr):Expr return e));
		@:await assertAtom(("Expected type NUMBER but found NULL."), (r.expr(null) + 5).default_(function(e:Expr):Expr return e));
		@:await assertAtom(("Expected type NUMBER but found NULL."), (5 + r.expr(null)).default_(function(e:Expr):Expr return e));
		@:await assertAtom(("Expected type NUMBER but found NULL."), (5 - r.expr(null)).default_(function(e:Expr):Expr return e));
		@:await assertAtom(("Expected type NUMBER but found NULL."), (r.expr(null) - 5).default_(function(e:Expr):Expr return e));
		var arr = r.expr(([{ "a" : 1 }, { "a" : null }, {  }] : Array<Dynamic>)).orderBy("a");
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].eq(1)));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : false }));
		@:await assertAtom(([{  }, { "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : true }));
		@:await assertAtom(([{  }, { "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : r.js("true") }));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : r.js("false") }));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `a` in object:", ([] : Array<Dynamic>)), arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : r.error() }));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), r.expr(false).do_(function(d:Expr):Expr return arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : d })));
		@:await assertAtom(([{  }, { "a" : 1 }] : Array<Dynamic>), r.expr(true).do_(function(d:Expr):Expr return arr.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : d })).orderBy("a"));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].default_(0).eq(1)));
		@:await assertAtom(([{  }, { "a" : null }, { "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].default_(1).eq(1)).orderBy("a"));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return x["a"].default_(r.error()).eq(1)));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), r.expr(0).do_(function(i:Expr):Expr return arr.filter(function(x:Expr):Expr return x["a"].default_(i).eq(1))));
		@:await assertAtom(([{  }, { "a" : null }, { "a" : 1 }] : Array<Dynamic>), r.expr(1).do_(function(i:Expr):Expr return arr.filter(function(x:Expr):Expr return x["a"].default_(i).eq(1))).orderBy("a"));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2))));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : false }));
		@:await assertAtom(([{  }, { "a" : null }, { "a" : 1 }] : Array<Dynamic>), arr.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : true }).orderBy("a"));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `a` in object:", ([] : Array<Dynamic>)), arr.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : r.error() }));
		@:await assertAtom(partial({ "tables_created" : 1 }), r.tableCreate("default_test"));
		@:await assertAtom(({ "deleted" : 0, "replaced" : 0, "generated_keys" : arrlen(3, uuid()), "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 3 }), r.table("default_test").insert(arr));
		var tbl = r.table("default_test").orderBy("a").pluck("a");
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return x["a"].eq(1)));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : false }));
		@:await assertAtom(([{  }, { "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : true }));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `a` in object:", ([] : Array<Dynamic>)), tbl.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : r.error() }));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), r.expr(false).do_(function(d:Expr):Expr return tbl.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : d })));
		@:await assertAtom(([{  }, { "a" : 1 }] : Array<Dynamic>), r.expr(true).do_(function(d:Expr):Expr return tbl.filter(function(x:Expr):Expr return x["a"].eq(1), { "default" : d })).orderBy("a"));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return x["a"].default_(0).eq(1)));
		@:await assertAtom(([{  }, { "a" : null }, { "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return x["a"].default_(1).eq(1)).orderBy("a"));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return x["a"].default_(r.error()).eq(1)));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), r.expr(0).do_(function(i:Expr):Expr return tbl.filter(function(x:Expr):Expr return x["a"].default_(i).eq(1))));
		@:await assertAtom(([{  }, { "a" : null }, { "a" : 1 }] : Array<Dynamic>), r.expr(1).do_(function(i:Expr):Expr return tbl.filter(function(x:Expr):Expr return x["a"].default_(i).eq(1))).orderBy("a"));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2))));
		@:await assertAtom(([{ "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : false }));
		@:await assertAtom(([{  }, { "a" : null }, { "a" : 1 }] : Array<Dynamic>), tbl.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : true }).orderBy("a"));
		@:await assertError(err("ReqlNonExistenceError", "No attribute `a` in object:", ([] : Array<Dynamic>)), tbl.filter(function(x:Expr):Expr return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : r.error() }));
		@:await assertAtom(partial({ "tables_dropped" : 1 }), r.tableDrop("default_test"));
		return Noise;
	}
}