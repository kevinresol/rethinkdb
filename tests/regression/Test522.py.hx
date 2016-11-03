package .regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test522.py extends TestBase {
	override function test() {
		assertAtom(null, tbl.insert([{ id : 0 }, { id : 1 }, { id : 2 }]));
	}
}