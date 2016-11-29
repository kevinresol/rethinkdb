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
		odd.insert(([{ "id" : 1, "num" : 1 }, { "id" : 3, "num" : 3 }, { "id" : 5, "num" : 5 }] : Array<Dynamic>));
		even.insert(([{ "id" : 2, "num" : 2 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }] : Array<Dynamic>));
		odd2.insert(([{ "id" : 7, "num" : 1 }, { "id" : 8, "num" : 3 }, { "id" : 9, "num" : 2 }] : Array<Dynamic>));
		@:await assertAtom(([{ "id" : 1, "num" : 1 }, { "id" : 3, "num" : 3 }, { "id" : 5, "num" : 5 }, { "id" : 2, "num" : 2 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }] : Array<Dynamic>), odd.orderBy("num").union(even.orderBy("num"), { "interleave" : false }));
		@:await assertAtom(([{ "id" : 2, "num" : 2 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }, { "id" : 1, "num" : 1 }, { "id" : 3, "num" : 3 }, { "id" : 5, "num" : 5 }] : Array<Dynamic>), even.orderBy("num").union(odd.orderBy("num"), { "interleave" : false }));
		@:await assertAtom(([{ "id" : 1, "num" : 1 }, { "id" : 2, "num" : 2 }, { "id" : 3, "num" : 3 }, { "id" : 4, "num" : 4 }, { "id" : 5, "num" : 5 }, { "id" : 6, "num" : 6 }] : Array<Dynamic>), odd.orderBy("num").union(even.orderBy("num"), { "interleave" : "num" }));
		@:await assertError(err("ReqlQueryLogicError", "The streams given as arguments are not ordered by given ordering."), odd.orderBy("num").union(even.orderBy("num"), { "interleave" : r.desc("num") }));
		@:await assertAtom(([{ "id" : 1, "num" : 1 }, { "id" : 2, "num" : 2 }, { "id" : 3, "num" : 3 }, { "id" : 4, "num" : 4 }, { "id" : 5, "num" : 5 }, { "id" : 6, "num" : 6 }] : Array<Dynamic>), odd.orderBy("num").union(even.orderBy("num"), { "interleave" : function(x:Expr):Expr return x["num"] }));
		@:await assertAtom(([{ "id" : 7, "num" : 1 }, { "id" : 2, "num" : 2 }, { "id" : 9, "num" : 2 }, { "id" : 8, "num" : 3 }, { "id" : 4, "num" : 4 }, { "id" : 6, "num" : 6 }] : Array<Dynamic>), odd2.orderBy("num", r.desc("id")).union(even.orderBy("num", r.desc("id")), { "interleave" : ([function(x:Expr):Expr return x["num"], function(x:Expr):Expr return x["id"]] : Array<Dynamic>) }));
		@:await assertError(err("ReqlServerCompileError", "DESC may only be used as an argument to ORDER_BY or UNION."), odd.orderBy("num").union(even.orderBy("num"), { "interleave" : function(x:Expr):Expr return r.desc(x["num"]) }));
		@:await assertAtom(([{ "id" : 6, "num" : 6 }, { "id" : 5, "num" : 5 }, { "id" : 4, "num" : 4 }, { "id" : 3, "num" : 3 }, { "id" : 2, "num" : 2 }, { "id" : 1, "num" : 1 }] : Array<Dynamic>), odd.orderBy(r.desc("num")).union(even.orderBy(r.desc("num")), { "interleave" : ([r.desc(function(x:Expr):Expr return x["num"])] : Array<Dynamic>) }));
		@:await assertError(err("ReqlQueryLogicError", "The streams given as arguments are not ordered by given ordering."), odd.orderBy("num", "id").union(even.orderBy("num", "id"), odd2.orderBy(r.desc("num"), "id"), { "interleave" : (["num", "id"] : Array<Dynamic>) }));
		@:await assertAtom(([for (x in range(0, 10000)) x] : Array<Dynamic>) + ([1, 2, 3] : Array<Dynamic>), r.range().limit(10000).union(([1, 2, 3] : Array<Dynamic>), { "interleave" : false }));
		@:await dropTables(_tables);
		return Noise;
	}
}