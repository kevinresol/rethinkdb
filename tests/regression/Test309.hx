package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test309 extends TestBase {
	override function test() {
		assertAtom(null, t.insert([{ id : 0 }, { id : 1 }]));
		assertAtom(bag([{ id : 0 }, { id : 1 }, 2, 3, 4]), t.union([2, 3, 4]));
		assertAtom(bag([{ id : 0 }, { id : 1 }, 2, 3, 4]), r.expr([2, 3, 4]).union(t));
	}
}