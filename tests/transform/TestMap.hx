package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestMap extends TestBase {
	override function test() {
		assertAtom([0, 0], r.range(3).map(function() return 0));
		assertAtom([0, 0], r.range(3).map(r.range(4), function(x, y) return 0));
		assertAtom([[0], [1], [2]], r.range(3).map(r.range(5), r.js("(function(x, y){return [x, y];})")));
		assertAtom([1, 3], r.map(r.range(3), r.row + 1));
	}
}