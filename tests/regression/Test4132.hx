package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4132 extends TestBase {
	override function test() {
		assertAtom(true, r.and());
		assertAtom(false, r.or());
		assertAtom("nil", r.expr(false).or(nil));
	}
}