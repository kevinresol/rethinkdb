package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test579 extends TestBase {
	override function test() {
		assertAtom(null, tbl.insert({ name : "Jim Brown" }));
		assertError("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic.", tbl.indexCreate("579", function(rec) return r.js("1")));
		assertError("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic.", tbl.indexCreate("579", function(rec) return tbl.get(0)));
	}
}