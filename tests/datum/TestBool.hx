package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class TestBool extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(false, r.expr(null).coerceTo("bool"));
			@:await assertAtom(true, r.expr(0).coerceTo("bool"));
			@:await assertAtom(true, r.expr("false").coerceTo("bool"));
			@:await assertAtom(true, r.expr("foo").coerceTo("bool"));
			@:await assertAtom(true, r.expr([]).coerceTo("bool"));
			@:await assertAtom(true, r.expr({  }).coerceTo("bool"));
		};
		return Noise;
	}
}