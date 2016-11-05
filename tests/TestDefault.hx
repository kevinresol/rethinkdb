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
		@:await assertError("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", r.expr(r.expr("a")["b"]).default_(2));
		@:await assertAtom(2, r.expr([]).reduce(function(a, b) return a + b).default_(2));
		@:await assertAtom(2, r.expr([]).union([]).reduce(function(a, b) return a + b).default_(2));
		@:await assertError("ReqlQueryLogicError", "Cannot convert STRING to SEQUENCE", r.expr("a").reduce(function(a, b) return a + b).default_(2));
		@:await assertAtom(2, (r.expr(null) + 5).default_(2));
		@:await assertAtom(2, (5 + r.expr(null)).default_(2));
		@:await assertAtom(2, (5 - r.expr(null)).default_(2));
		@:await assertAtom(2, (r.expr(null) - 5).default_(2));
		@:await assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", (r.expr("a") + 5).default_(2));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", (5 + r.expr("a")).default_(2));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", (r.expr("a") - 5).default_(2));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", (5 - r.expr("a")).default_(2));
		@:await assertAtom(1, r.expr(1).default_(r.error()));
		@:await assertAtom(null, r.expr(null).default_(r.error()));
		@:await assertError("ReqlNonExistenceError", "No attribute `b` in object:", r.expr({  })["b"].default_(r.error()));
		@:await assertError("ReqlNonExistenceError", "Cannot reduce over an empty stream.", r.expr([]).reduce(function(a, b) return a + b).default_(r.error));
		@:await assertError("ReqlNonExistenceError", "Cannot reduce over an empty stream.", r.expr([]).union([]).reduce(function(a, b) return a + b).default_(r.error));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (r.expr(null) + 5).default_(r.error));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (5 + r.expr(null)).default_(r.error));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (5 - r.expr(null)).default_(r.error));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (r.expr(null) - 5).default_(r.error));
		@:await assertAtom(1, r.expr(1).default_(function(e) return e));
		@:await assertAtom(null, r.expr(null).default_(function(e) return e));
		@:await assertAtom("No attribute `b` in object:\n{}", r.expr({  })["b"].default_(function(e) return e));
		@:await assertAtom("Cannot reduce over an empty stream.", r.expr([]).reduce(function(a, b) return a + b).default_(function(e) return e));
		@:await assertAtom("Cannot reduce over an empty stream.", r.expr([]).union([]).reduce(function(a, b) return a + b).default_(function(e) return e));
		@:await assertAtom("Expected type NUMBER but found NULL.", (r.expr(null) + 5).default_(function(e) return e));
		@:await assertAtom("Expected type NUMBER but found NULL.", (5 + r.expr(null)).default_(function(e) return e));
		@:await assertAtom("Expected type NUMBER but found NULL.", (5 - r.expr(null)).default_(function(e) return e));
		@:await assertAtom("Expected type NUMBER but found NULL.", (r.expr(null) - 5).default_(function(e) return e));
		var arr = r.expr([{ "a" : 1 }, { "a" : null }, {  }]).orderBy("a");
		@:await assertAtom([{ "a" : 1 }], arr.filter(function(x) return x["a"].eq(1)));
		@:await assertAtom([{  }, { "a" : 1 }], arr.filter(function(x) return x["a"].eq(1), { "default" : r.js("true") }));
		@:await assertAtom([{ "a" : 1 }], arr.filter(function(x) return x["a"].eq(1), { "default" : r.js("false") }));
		@:await assertError("ReqlNonExistenceError", "No attribute `a` in object:", arr.filter(function(x) return x["a"].eq(1), { "default" : r.error() }));
		@:await assertAtom([{ "a" : 1 }], arr.filter(function(x) return x["a"].default_(0).eq(1)));
		@:await assertAtom([{  }, { "a" : null }, { "a" : 1 }], arr.filter(function(x) return x["a"].default_(1).eq(1)).orderBy("a"));
		@:await assertAtom([{ "a" : 1 }], arr.filter(function(x) return x["a"].default_(r.error()).eq(1)));
		@:await assertAtom([{ "a" : 1 }], r.expr(0).do_(function(i) return arr.filter(function(x) return x["a"].default_(i).eq(1))));
		@:await assertAtom([{  }, { "a" : null }, { "a" : 1 }], r.expr(1).do_(function(i) return arr.filter(function(x) return x["a"].default_(i).eq(1))).orderBy("a"));
		@:await assertAtom([{ "a" : 1 }], arr.filter(function(x) return r.or(x["a"].eq(1), x["a"]["b"].eq(2))));
		@:await assertError("ReqlNonExistenceError", "No attribute `a` in object:", arr.filter(function(x) return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : r.error() }));
		@:await assertPartial({ "tables_created" : 1 }, r.tableCreate("default_test"));
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "generated_keys" : arrlen(3, uuid()), "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 3 }, r.table("default_test").insert(arr));
		var tbl = r.table("default_test").orderBy("a").pluck("a");
		@:await assertAtom([{ "a" : 1 }], tbl.filter(function(x) return x["a"].eq(1)));
		@:await assertError("ReqlNonExistenceError", "No attribute `a` in object:", tbl.filter(function(x) return x["a"].eq(1), { "default" : r.error() }));
		@:await assertAtom([{ "a" : 1 }], tbl.filter(function(x) return x["a"].default_(0).eq(1)));
		@:await assertAtom([{  }, { "a" : null }, { "a" : 1 }], tbl.filter(function(x) return x["a"].default_(1).eq(1)).orderBy("a"));
		@:await assertAtom([{ "a" : 1 }], tbl.filter(function(x) return x["a"].default_(r.error()).eq(1)));
		@:await assertAtom([{ "a" : 1 }], r.expr(0).do_(function(i) return tbl.filter(function(x) return x["a"].default_(i).eq(1))));
		@:await assertAtom([{  }, { "a" : null }, { "a" : 1 }], r.expr(1).do_(function(i) return tbl.filter(function(x) return x["a"].default_(i).eq(1))).orderBy("a"));
		@:await assertAtom([{ "a" : 1 }], tbl.filter(function(x) return r.or(x["a"].eq(1), x["a"]["b"].eq(2))));
		@:await assertError("ReqlNonExistenceError", "No attribute `a` in object:", tbl.filter(function(x) return r.or(x["a"].eq(1), x["a"]["b"].eq(2)), { "default" : r.error() }));
		@:await assertPartial({ "tables_dropped" : 1 }, r.tableDrop("default_test"));
		return Noise;
	}
}