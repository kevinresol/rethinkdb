package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2709 extends TestBase {
	override function test() {
		assertAtom((999), tbl.map(function(thing) return "key").count());
		assertAtom((999), tbl.map(function(thing) return "key").count());
	}
}