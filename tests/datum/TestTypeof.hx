package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestTypeof extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom("NULL", r.expr(null).typeOf());
			@:await assertAtom("NULL", r.typeOf(null));
		};
		return Noise;
	}
}