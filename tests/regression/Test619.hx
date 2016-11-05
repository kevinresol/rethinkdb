package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test619 extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(({ "self" : "foo" }), r.expr({ "self" : "foo" }));
		@:await assertAtom(({ "self" : 1 }), r.expr(1).do_(function(x) return { "self" : x }));
		@:await assertAtom(({ "a" : { "self" : 1 } }), r.expr({ "a" : { "self" : 1 } }));
		@:await assertAtom(({ "self" : { "self" : { "self" : 1 } } }), r.expr({ "self" : { "self" : { "self" : 1 } } }));
		return Noise;
	}
}