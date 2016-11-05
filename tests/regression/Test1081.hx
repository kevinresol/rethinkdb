package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test1081 extends TestBase {
	@:async
	override function test() {
		{
			var t = r.db("test").table("t1081");
		};
		return Noise;
	}
}