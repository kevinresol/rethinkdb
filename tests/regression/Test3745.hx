package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test3745 extends TestBase {
	override function test() {
		assertAtom("partial({\'inserted\':2})", tbl.insert([{ "id" : 0, "a" : 5 }, { "id" : 1, "a" : 6 }]));
		assertAtom({ "a" : 11 }, tbl.reduce(function(x, y) return r.object("a", r.add(x["a"], y["a"]))));
		assertError("ReqlQueryLogicError", "Cannot convert NUMBER to SEQUENCE", tbl.reduce(function(x, y) return r.expr(0)[0]));
	}
}