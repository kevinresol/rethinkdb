package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test546 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(1, r.expr(1).do_(function(a) return a));
			@:await assertAtom(2, r.expr(1).do_(function(a) return r.expr(2).do_(function(b) return b)));
			@:await assertAtom(1, r.expr(1).do_(function(a) return r.expr(2).do_(function(b) return a)));
		};
		return Noise;
	}
}