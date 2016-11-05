package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test2709 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(999, tbl.map(function(thing) return "key").count());
			@:await assertAtom(999, tbl.map(function(thing) return "key").count());
		};
		return Noise;
	}
}