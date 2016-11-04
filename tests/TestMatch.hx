package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestMatch extends TestBase {
	override function test() {
		assertAtom({ "str" : "bcde", "groups" : [null, { "start" : 2, "str" : "cde", "end" : 5 }], "start" : 1, "end" : 5 }, r.expr("abcdefg").match("a(b.e)|b(c.e)"));
		assertAtom(null, r.expr("abcdefg").match("a(b.e)|B(c.e)"));
		assertAtom({ "str" : "bcde", "groups" : [null, { "start" : 2, "str" : "cde", "end" : 5 }], "start" : 1, "end" : 5 }, r.expr("abcdefg").match("(?i)a(b.e)|B(c.e)"));
		assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 3 }, tbl.insert([{ "id" : 0, "a" : "abc" }, { "id" : 1, "a" : "ab" }, { "id" : 2, "a" : "bc" }]));
		assertAtom([{ "id" : 0, "a" : "abc" }, { "id" : 1, "a" : "ab" }, { "id" : 2, "a" : "bc" }], tbl.filter(function(row) return row["a"].match("b")).orderBy("id"));
		assertAtom([{ "id" : 0, "a" : "abc" }, { "id" : 1, "a" : "ab" }], tbl.filter(function(row) return row["a"].match("ab")).orderBy("id"));
		assertAtom([{ "id" : 1, "a" : "ab" }], tbl.filter(function(row) return row["a"].match("ab$")).orderBy("id"));
		assertAtom([], tbl.filter(function(row) return row["a"].match("^b$")).orderBy("id"));
		assertError("ReqlQueryLogicError", "Error in regexp `ab\\9` (portion `\\9`): invalid escape sequence: \\9", r.expr("").match("ab\\9"));
	}
}