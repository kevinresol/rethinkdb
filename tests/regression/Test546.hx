package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test546 extends TestBase {
	override function test() {
		assertAtom(1, r.expr(1).do_(function(a) return a));
		assertAtom(2, r.expr(1).do_(function(a) return r.expr(2).do_(function(b) return b)));
		assertAtom(1, r.expr(1).do_(function(a) return r.expr(2).do_(function(b) return a)));
	}
}