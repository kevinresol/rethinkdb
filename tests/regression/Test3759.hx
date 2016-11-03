package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test3759 extends TestBase {
	override function test() {
		assertAtom([1], r.db("rethinkdb").table("jobs").map(function() return 1));
		assertAtom(null, r.db("rethinkdb").table("jobs").map(function() return 1));
		assertAtom(null, r.db("rethinkdb").table("jobs").map(function() return 1));
		assertAtom([1], r.db("rethinkdb").table("jobs").map(function() return 1));
	}
}