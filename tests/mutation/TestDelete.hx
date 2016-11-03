package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestDelete extends TestBase {
	override function test() {
		assertAtom(100, tbl.count());
		assertAtom(({ deleted : 1, replaced : 0, unchanged : 0, errors : 0, skipped : 0, inserted : 0 }), tbl.get(12).delete());
		assertError("ReqlQueryLogicError", "Durability option `wrong` unrecognized (options are \"hard\" and \"soft\").", tbl.skip(50).delete({ durability : "wrong" }));
		assertAtom(({ deleted : 49, replaced : 0, unchanged : 0, errors : 0, skipped : 0, inserted : 0 }), tbl.skip(50).delete({ durability : "soft" }));
		assertAtom(({ deleted : 50, replaced : 0, unchanged : 0, errors : 0, skipped : 0, inserted : 0 }), tbl.delete({ durability : "hard" }));
		assertError("ReqlQueryLogicError", "Expected type SELECTION but found DATUM:", r.expr([1, 2]).delete());
	}
}