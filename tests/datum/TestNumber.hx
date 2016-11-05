package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class TestNumber extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(1, r.expr(1));
			@:await assertAtom(-1, r.expr(-1));
			@:await assertAtom(0, r.expr(0));
			@:await assertAtom(1, r.expr(1.0));
			@:await assertAtom(1.5, r.expr(1.5));
			@:await assertAtom(-0.5, r.expr(-0.5));
			@:await assertAtom(67498.89278, r.expr(67498.89278));
			@:await assertAtom(1234567890, r.expr(1234567890));
			@:await assertAtom(-73850380122423, r.expr(-73850380122423));
			@:await assertAtom(123.45678901234568, r.expr(123.4567890123456789012345678901234567890));
			@:await assertAtom("NUMBER", r.expr(1).typeOf());
			@:await assertAtom("1", r.expr(1).coerceTo("string"));
			@:await assertAtom(1, r.expr(1).coerceTo("number"));
			@:await assertAtom("int_cmp(1)", r.expr(1.0));
			@:await assertAtom("int_cmp(45)", r.expr(45));
			@:await assertAtom("float_cmp(1.2)", r.expr(1.2));
		};
		return Noise;
	}
}