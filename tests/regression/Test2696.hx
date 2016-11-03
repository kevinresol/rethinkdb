package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2696 extends TestBase {
	override function test() {
		assertAtom([1, 3], r.expr([1, 3]).deleteAt(4));
		assertAtom([], r.expr([]).deleteAt(0));
	}
}