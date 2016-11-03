package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestUpdate extends TestBase {
	override function test() {
		assertAtom(100, tbl.count());
		assertAtom(100, tbl2.count());
		assertError("ReqlQueryLogicError", "Durability option `wrong` unrecognized (options are \"hard\" and \"soft\").", tbl.get(12).update(function(row) return { a : row["id"] + 3 }, { durability : "wrong" }));
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).update({ d : r.js("5") }));
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).update({ d : tbl.nth(0) }));
	}
}