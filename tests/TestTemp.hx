import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestTemp extends TestBase {
	override function test() {
		assertAtom(1, r.expr(1).default_(2));
		assertAtom(2, r.expr(null).default_(2));
		assertAtom(2, r.expr({  })["b"].default_(2));
		assertError("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", r.expr(r.expr("a")["b"]).default_(2));
		assertAtom(2, r.expr([]).reduce(function(a, b) return a + b).default_(2));
		assertAtom(2, r.expr([]).union([]).reduce(function(a, b) return a + b).default_(2));
		assertError("ReqlQueryLogicError", "Cannot convert STRING to SEQUENCE", r.expr("a").reduce(function(a, b) return a + b).default_(2));
		assertAtom(2, (r.expr(null) + 5).default_(2));
		assertAtom(2, (5 + r.expr(null)).default_(2));
		assertAtom(2, (5 - r.expr(null)).default_(2));
		assertAtom(2, (r.expr(null) - 5).default_(2));
		assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", (r.expr("a") + 5).default_(2));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", (5 + r.expr("a")).default_(2));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", (r.expr("a") - 5).default_(2));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", (5 - r.expr("a")).default_(2));
		assertAtom(1, r.expr(1).default_(r.error()));
		assertAtom((null), r.expr(null).default_(r.error()));
		assertError("ReqlNonExistenceError", "No attribute `b` in object:", r.expr({  })["b"].default_(r.error()));
		assertError("ReqlNonExistenceError", "Cannot reduce over an empty stream.", r.expr([]).reduce(function(a, b) return a + b).default_(r.error()));
		assertError("ReqlNonExistenceError", "Cannot reduce over an empty stream.", r.expr([]).union([]).reduce(function(a, b) return a + b).default_(r.error()));
		assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (r.expr(null) + 5).default_(r.error()));
		assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (5 + r.expr(null)).default_(r.error()));
		assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (5 - r.expr(null)).default_(r.error()));
		assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", (r.expr(null) - 5).default_(r.error()));
		assertAtom(1, r.expr(1).default_(function(e) return e));
		assertAtom((null), r.expr(null).default_(function(e) return e));
		assertAtom(("Cannot reduce over an empty stream."), r.expr([]).reduce(function(a, b) return a + b).default_(function(e) return e));
		assertAtom(("Cannot reduce over an empty stream."), r.expr([]).union([]).reduce(function(a, b) return a + b).default_(function(e) return e));
		assertAtom(("Expected type NUMBER but found NULL."), (r.expr(null) + 5).default_(function(e) return e));
		assertAtom(("Expected type NUMBER but found NULL."), (5 + r.expr(null)).default_(function(e) return e));
		assertAtom(("Expected type NUMBER but found NULL."), (5 - r.expr(null)).default_(function(e) return e));
		assertAtom(("Expected type NUMBER but found NULL."), (r.expr(null) - 5).default_(function(e) return e));
		// assertAtom(([{  }, { a : null }, { a : 1 }]), arr.filter(function(x) return x["a"].default_(1).eq(1)).order_by("a"));
		// assertAtom(([{  }, { a : null }, { a : 1 }]), r.expr(1).do_(function(i) return arr.filter(function(x) return x["a"].default_(i).eq(1))).order_by("a"));
		// assertAtom(partial({ tables_created : 1 }), r.table_create("default_test"));
		// assertAtom(({ deleted : 0, replaced : 0, generated_keys : arrlen(3, uuid()), unchanged : 0, errors : 0, skipped : 0, inserted : 3 }), r.table("default_test").insert(arr));
		// assertAtom(([{  }, { a : null }, { a : 1 }]), tbl.filter(function(x) return x["a"].default_(1).eq(1)).order_by("a"));
		// assertAtom(([{  }, { a : null }, { a : 1 }]), r.expr(1).do_(function(i) return tbl.filter(function(x) return x["a"].default_(i).eq(1))).order_by("a"));
		// assertAtom(partial({ tables_dropped : 1 }), r.table_drop("default_test"));
	}
}