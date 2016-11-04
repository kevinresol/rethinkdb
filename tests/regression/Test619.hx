package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test619 extends TestBase {
	override function test() {
		assertAtom({ "self" : "foo" }, r.expr({ "self" : "foo" }));
		assertAtom({ "self" : 1 }, r.expr(1).do_(function(x) return { "self" : x }));
	}
}