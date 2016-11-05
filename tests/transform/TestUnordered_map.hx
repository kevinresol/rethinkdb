package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestUnordered_map extends TestBase {
	@:async
	override function test() {
		var _tables = ["even", "odd", "odd2"];
		@:await createTables(_tables);
		var even = r.db("test").table("even"), odd = r.db("test").table("odd"), odd2 = r.db("test").table("odd2");
		@:await assertAtom([{ "id" : 1, "num" : 1 }, { "id" : 3, "num" : 3 }, { "id" : 5, "num" : 5 }, { "id" : 2, "num" : 2 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }], odd.orderBy("num").union(even.orderBy("num"), { "interleave" : false }));
		@:await assertAtom([{ "id" : 2, "num" : 2 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }, { "id" : 1, "num" : 1 }, { "id" : 3, "num" : 3 }, { "id" : 5, "num" : 5 }], even.orderBy("num").union(odd.orderBy("num"), { "interleave" : false }));
		@:await assertAtom([{ "id" : 1, "num" : 1 }, { "id" : 2, "num" : 2 }, { "id" : 3, "num" : 3 }, { "id" : 4, "num" : 4 }, { "id" : 5, "num" : 5 }, { "id" : 6, "num" : 6 }], odd.orderBy("num").union(even.orderBy("num"), { "interleave" : "num" }));
		@:await assertError("ReqlQueryLogicError", "The streams given as arguments are not ordered by given ordering.", odd.orderBy("num").union(even.orderBy("num"), { "interleave" : r.desc("num") }));
		@:await assertAtom([{ "id" : 1, "num" : 1 }, { "id" : 2, "num" : 2 }, { "id" : 3, "num" : 3 }, { "id" : 4, "num" : 4 }, { "id" : 5, "num" : 5 }, { "id" : 6, "num" : 6 }], odd.orderBy("num").union(even.orderBy("num"), { "interleave" : function(x) return x["num"] }));
		@:await assertAtom([{ "id" : 7, "num" : 1 }, { "id" : 2, "num" : 2 }, { "id" : 9, "num" : 2 }, { "id" : 8, "num" : 3 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }], odd2.orderBy("num", r.desc("id")).union(even.orderBy("num", r.desc("id")), { "interleave" : [function(x) return x["num"], function(x) return x["id"]] }));
		@:await assertError("ReqlServerCompileError", "DESC may only be used as an argument to ORDER_BY or UNION.", odd.orderBy("num").union(even.orderBy("num"), { "interleave" : function(x) return r.desc(x["num"]) }));
		@:await assertAtom([{ "id" : 6, "num" : 6 }, { "id" : 5, "num" : 5 }, { "id" : 4, "num" : 4 }, { "id" : 3, "num" : 3 }, { "id" : 2, "num" : 2 }, { "id" : 1, "num" : 1 }], odd.orderBy(r.desc("num")).union(even.orderBy(r.desc("num")), { "interleave" : [r.desc(function(x) return x["num"])] }));
		@:await assertError("ReqlQueryLogicError", "The streams given as arguments are not ordered by given ordering.", odd.orderBy("num", "id").union(even.orderBy("num", "id"), odd2.orderBy(r.desc("num"), "id"), { "interleave" : ["num", "id"] }));
		@:await assertAtom([for (x in range(0, 10000)) x] + [1, 2, 3], r.range().limit(10000).union([1, 2, 3], { "interleave" : false }));
		@:await dropTables(_tables);
		return Noise;
	}
}