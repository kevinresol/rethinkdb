package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestNumber extends TestBase {
	override function test() {
		assertAtom(1, r.expr(1));
		assertAtom(-1, r.expr(-1));
		assertAtom(0, r.expr(0));
		assertAtom(1, r.expr(1.0));
		assertAtom(1.5, r.expr(1.5));
		assertAtom(-0.5, r.expr(-0.5));
		assertAtom(67498.89278, r.expr(67498.89278));
		assertAtom(1234567890, r.expr(1234567890));
		assertAtom(-73850380122423, r.expr(-73850380122423));
		assertAtom(123.45678901234568, r.expr(123.4567890123456789012345678901234567890));
		assertAtom("NUMBER", r.expr(1).typeOf());
		assertAtom("1", r.expr(1).coerceTo("string"));
		assertAtom(1, r.expr(1).coerceTo("number"));
		assertAtom("int_cmp(1)", r.expr(1.0));
		assertAtom("int_cmp(45)", r.expr(45));
		assertAtom("float_cmp(1.2)", r.expr(1.2));
	}
}