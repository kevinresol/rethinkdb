package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestPolymorphism extends TestBase {
	override function test() {
		var obj = r.expr({ id : 0, a : 0 });
	}
}