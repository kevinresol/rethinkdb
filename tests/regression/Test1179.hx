package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1179 extends TestBase {
	override function test() {
		assertAtom(1, r.expr([1])[r.expr(0)]);
	}
}