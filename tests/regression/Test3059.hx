package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test3059 extends TestBase {
	@:async
	override function test() {
		@:await assertAtom("PTYPE<GEOMETRY>", r.point(0, 1).typeOf());
		@:await assertAtom("PTYPE<GEOMETRY>", r.point(0, 1).info()["type"]);
		return Noise;
	}
}