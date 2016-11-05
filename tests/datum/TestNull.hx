package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestNull extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(null, r.expr(null));
		@:await assertAtom("NULL", r.expr(null).typeOf());
		@:await assertAtom("null", r.expr(null).coerceTo("string"));
		@:await assertAtom(null, r.expr(null).coerceTo("null"));
		return Noise;
	}
}