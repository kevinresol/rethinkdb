package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestBool extends TestBase {
	override function test() {
		assertAtom(false, r.expr(null).coerceTo("bool"));
		assertAtom(true, r.expr(0).coerceTo("bool"));
		assertAtom(true, r.expr("false").coerceTo("bool"));
		assertAtom(true, r.expr("foo").coerceTo("bool"));
		assertAtom(true, r.expr([]).coerceTo("bool"));
		assertAtom(true, r.expr({  }).coerceTo("bool"));
	}
}