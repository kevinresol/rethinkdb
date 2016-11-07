package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestFold extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 100 }, tbl.insert(r.range(100).map(function(i:Expr):Expr return { "id" : i, "a" : i % 4 }).coerceTo("array")));
		@:await assertAtom(10, r.range(0, 10).fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1)));
		@:await assertAtom(20, r.range(0, 10).fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "final_emit" : function(acc:Expr):Expr return acc.mul(2) }));
		@:await assertAtom([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], r.range(0, 10).fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return [row] }).coerceTo("array"));
		@:await assertAtom([2, 5, 8, 10], r.range(0, 10).fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return r.branch(acc.mod(3).eq(0), [row], []), "final_emit" : function(acc:Expr):Expr return [acc] }).coerceTo("array"));
		@:await assertAtom([1, 2, 3, 5, 8, 13, 21, 34, 55, 89], r.range(0, 10).fold([1, 1], function(acc:Expr, row:Expr):Expr return [acc[1], acc[0].add(acc[1])], { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return [acc[0]] }).coerceTo("array"));
		@:await assertAtom("STREAM", r.range(0, 10).fold(0, function(acc:Expr, row:Expr):Expr return acc, { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return acc }).typeOf());
		@:await assertAtom([{ "a" : 0, "id" : 20 }, { "a" : 3, "id" : 15 }, { "a" : 2, "id" : 46 }, { "a" : 2, "id" : 78 }, { "a" : 2, "id" : 90 }], tbl.filter("id").fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return r.branch(old.mod(20).eq(0), [row], []) }).coerceTo("array"));
		@:await assertAtom([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], r.range().fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return [acc] }).limit(10));
		@:await assertError(err("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array."), r.range().fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return [acc] }).map(function(doc:Expr):Expr return 1).reduce(function(l:Expr, r:Expr):Expr return l + r));
		@:await assertAtom([for (x in range(1, 1001)) x], r.range(0, 1000).fold(0, function(acc:Expr, row:Expr):Expr return acc.add(1), { "emit" : function(old:Expr, row:Expr, acc:Expr):Expr return [acc] }).coerceTo("array"));
		@:await dropTables(_tables);
		return Noise;
	}
}