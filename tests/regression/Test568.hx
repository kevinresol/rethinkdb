package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test568 extends TestBase {
	override function test() {
		assertAtom(null, tbl.insert({ name : "Jim Brown" }));
		assertError("ReqlQueryLogicError", "Cannot convert STRING to SEQUENCE", tbl.concatMap(function(rec) return rec["name"]));
	}
}