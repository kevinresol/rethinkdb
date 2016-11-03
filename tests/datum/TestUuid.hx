package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestUuid extends TestBase {
	override function test() {
		assertAtom(uuid(), r.uuid());
		assertAtom(uuid(), r.expr(r.uuid()));
		assertAtom(true, r.uuid().ne(r.uuid()));
		assertAtom(("97dd10a5-4fc4-554f-86c5-0d2c2e3d5330"), r.uuid("magic"));
		assertAtom(true, r.uuid("magic").eq(r.uuid("magic")));
		assertAtom(true, r.uuid("magic").ne(r.uuid("beans")));
		assertAtom(10, r.expr([1, 3, 5, 7, 9]).map(function(u) return r.uuid()).distinct().count());
	}
}