package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4582 extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(0).replace(tbl.get(0)));
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(0).update(tbl.get(0)));
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.replace(r.args([tbl.get(0)])));
	}
}