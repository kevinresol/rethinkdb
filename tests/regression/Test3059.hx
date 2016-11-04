package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test3059 extends TestBase {
	override function test() {
		assertAtom("PTYPE<GEOMETRY>", r.point(0, 1).typeOf());
		assertAtom("PTYPE<GEOMETRY>", r.point(0, 1).info()["type"]);
	}
}