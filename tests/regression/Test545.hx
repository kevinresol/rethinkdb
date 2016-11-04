package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test545 extends TestBase {
	override function test() {
		assertAtom(1, tbl.reduce(r.js("(function(x,y){return 1;})")));
		assertAtom({ "id" : 3 }, tbl.reduce(r.js("(function(x,y){return {id:x[\"id\"] + y[\"id\"]};})")));
	}
}