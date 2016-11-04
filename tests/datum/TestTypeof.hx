package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestTypeof extends TestBase {
	override function test() {
		assertAtom("NULL", r.expr(null).typeOf());
		assertAtom("NULL", r.typeOf(null));
	}
}