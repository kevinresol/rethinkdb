package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestMap extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom([0, 0, 0], r.range(3).map(function() return 0));
			@:await assertAtom([0, 0, 0], r.range(3).map(r.range(4), function(x, y) return 0));
			@:await assertAtom([[0, 0], [1, 1], [2, 2]], r.range(3).map(r.range(5), r.js("(function(x, y){return [x, y];})")));
			@:await assertAtom([1, 2, 3], r.map(r.range(3), r.row + 1));
		};
		return Noise;
	}
}