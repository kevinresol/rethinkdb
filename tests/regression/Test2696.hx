package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2696 extends TestBase {
	override function test() {
		assertAtom([1, 2, 3, 4], r.expr([1, 2, 3, 4]).deleteAt(4, 4));
		assertAtom([], r.expr([]).deleteAt(0, 0));
	}
}