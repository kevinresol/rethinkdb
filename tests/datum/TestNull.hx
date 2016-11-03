package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestNull extends TestBase {
	override function test() {
		assertAtom((null), r.expr(null));
		assertAtom(null, r.expr(null).coerceTo("string"));
		assertAtom(null, r.expr(null).coerceTo("null"));
	}
}