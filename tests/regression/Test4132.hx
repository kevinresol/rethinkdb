package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4132 extends TestBase {
	override function test() {
		assertAtom(true, r.and_());
		assertAtom(false, r.or_());
		assertAtom("nil", r.expr(false).or_(nil));
	}
}