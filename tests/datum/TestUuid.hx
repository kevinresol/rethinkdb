package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestUuid extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(uuid(), r.uuid());
		@:await assertAtom(uuid(), r.expr(r.uuid()));
		@:await assertAtom("STRING", r.typeOf(r.uuid()));
		@:await assertAtom(true, r.uuid().ne(r.uuid()));
		@:await assertAtom(("97dd10a5-4fc4-554f-86c5-0d2c2e3d5330"), r.uuid("magic"));
		@:await assertAtom(true, r.uuid("magic").eq(r.uuid("magic")));
		@:await assertAtom(true, r.uuid("magic").ne(r.uuid("beans")));
		@:await assertAtom(10, r.expr([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).map(function(u) return r.uuid()).distinct().count());
		return Noise;
	}
}