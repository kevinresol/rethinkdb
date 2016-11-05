package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test1001 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(1, tbl.between(r.minval, r.maxval).count());
			@:await assertAtom(0, tbl.between(r.minval, r.maxval, { "index" : "a" }).count());
			@:await assertAtom(0, tbl.between(r.minval, r.maxval, { "index" : "b" }).count());
		};
		return Noise;
	}
}