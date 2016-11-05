package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test3759 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom([1], r.db("rethinkdb").table("jobs").map(function() return 1));
			@:await assertAtom(null, r.db("rethinkdb").table("jobs").map(function() return 1));
			@:await assertAtom(null, r.db("rethinkdb").table("jobs").map(function() return 1));
			@:await assertAtom([1], r.db("rethinkdb").table("jobs").map(function() return 1));
		};
		return Noise;
	}
}