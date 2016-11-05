package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestFloor_ceil_round extends TestBase {
	@:async
	override function test() {
		@:await assertAtom("NUMBER", r.floor(1.0).typeOf());
		@:await assertAtom(1, r.floor(1.0));
		@:await assertAtom(1, r.expr(1.0).floor());
		@:await assertAtom(0, r.floor(0.5));
		@:await assertAtom(1, r.floor(1.0));
		@:await assertAtom(1, r.floor(1.5));
		@:await assertAtom(-1, r.floor(-0.5));
		@:await assertAtom(-1, r.floor(-1.0));
		@:await assertAtom(-2, r.floor(-1.5));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("X").floor());
		@:await assertAtom("NUMBER", r.ceil(1.0).typeOf());
		@:await assertAtom(1, r.ceil(1.0));
		@:await assertAtom(1, r.expr(1.0).ceil());
		@:await assertAtom(1, r.ceil(0.5));
		@:await assertAtom(1, r.ceil(1.0));
		@:await assertAtom(2, r.ceil(1.5));
		@:await assertAtom(0, r.ceil(-0.5));
		@:await assertAtom(-1, r.ceil(-1.0));
		@:await assertAtom(-1, r.ceil(-1.5));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("X").ceil());
		@:await assertAtom("NUMBER", r.round(1.0).typeOf());
		@:await assertAtom(1, r.round(1.0));
		@:await assertAtom(1, r.expr(1.0).round());
		@:await assertAtom(1, r.round(0.5));
		@:await assertAtom(-1, r.round(-0.5));
		@:await assertAtom(0, r.round(0.0));
		@:await assertAtom(1, r.round(1.0));
		@:await assertAtom(10, r.round(10.0));
		@:await assertAtom(1000000000, r.round(1000000000.0));
		@:await assertAtom(-1, r.round(-1.0));
		@:await assertAtom(-10, r.round(-10.0));
		@:await assertAtom(-1000000000, r.round(-1000000000.0));
		@:await assertAtom(0, r.round(0.1));
		@:await assertAtom(1, r.round(1.1));
		@:await assertAtom(10, r.round(10.1));
		@:await assertAtom(1000000000, r.round(1000000000.1));
		@:await assertAtom(-1, r.round(-1.1));
		@:await assertAtom(-10, r.round(-10.1));
		@:await assertAtom(-1000000000, r.round(-1000000000.1));
		@:await assertAtom(1, r.round(0.9));
		@:await assertAtom(10, r.round(9.9));
		@:await assertAtom(1000000000, r.round(999999999.9));
		@:await assertAtom(-1, r.round(-0.9));
		@:await assertAtom(-10, r.round(-9.9));
		@:await assertAtom(-1000000000, r.round(-999999999.9));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("X").round());
		return Noise;
	}
}