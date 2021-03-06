package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestMatch extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom(({ "str" : "bcde", "groups" : ([null, { "start" : 2, "str" : "cde", "end" : 5 }] : Array<Dynamic>), "start" : 1, "end" : 5 }), r.expr("abcdefg").match("a(b.e)|b(c.e)"));
		@:await assertAtom((null), r.expr("abcdefg").match("a(b.e)|B(c.e)"));
		@:await assertAtom(({ "str" : "bcde", "groups" : ([null, { "start" : 2, "str" : "cde", "end" : 5 }] : Array<Dynamic>), "start" : 1, "end" : 5 }), r.expr("abcdefg").match("(?i)a(b.e)|B(c.e)"));
		@:await assertAtom(((["aca", "ada"] : Array<Dynamic>)), r.expr((["aba", "aca", "ada", "aea"] : Array<Dynamic>)).filter(function(row:Expr):Expr return row.match("a(.)a")["groups"][0]["str"].match("[cd]")));
		@:await assertAtom(({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 3 }), tbl.insert(([{ "id" : 0, "a" : "abc" }, { "id" : 1, "a" : "ab" }, { "id" : 2, "a" : "bc" }] : Array<Dynamic>)));
		@:await assertAtom((([{ "id" : 0, "a" : "abc" }, { "id" : 1, "a" : "ab" }, { "id" : 2, "a" : "bc" }] : Array<Dynamic>)), tbl.filter(function(row:Expr):Expr return row["a"].match("b")).orderBy("id"));
		@:await assertAtom((([{ "id" : 0, "a" : "abc" }, { "id" : 1, "a" : "ab" }] : Array<Dynamic>)), tbl.filter(function(row:Expr):Expr return row["a"].match("ab")).orderBy("id"));
		@:await assertAtom((([{ "id" : 1, "a" : "ab" }] : Array<Dynamic>)), tbl.filter(function(row:Expr):Expr return row["a"].match("ab$")).orderBy("id"));
		@:await assertAtom((([] : Array<Dynamic>)), tbl.filter(function(row:Expr):Expr return row["a"].match("^b$")).orderBy("id"));
		@:await assertError(err("ReqlQueryLogicError", "Error in regexp `ab\\9` (portion `\\9`): invalid escape sequence: \\9", ([] : Array<Dynamic>)), r.expr("").match("ab\\9"));
		@:await dropTables(_tables);
		return Noise;
	}
}