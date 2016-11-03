package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test1081 extends TestBase {
	override function test() {
		var t = r.db("test").table("t1081");
	}
}