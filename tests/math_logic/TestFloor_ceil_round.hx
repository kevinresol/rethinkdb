package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestFloor_ceil_round extends TestBase {
	override function test() {
		assertAtom(1, r.floor(1));
		assertAtom(1, r.expr(1).floor());
		assertAtom(0, r.floor(0.5));
		assertAtom(1, r.floor(1));
		assertAtom(1, r.floor(1.5));
		assertAtom(-1, r.floor(-0.5));
		assertAtom(-1, r.floor(-1));
		assertAtom(-2, r.floor(-1.5));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("X").floor());
		assertAtom(1, r.ceil(1));
		assertAtom(1, r.expr(1).ceil());
		assertAtom(1, r.ceil(0.5));
		assertAtom(1, r.ceil(1));
		assertAtom(2, r.ceil(1.5));
		assertAtom(0, r.ceil(-0.5));
		assertAtom(-1, r.ceil(-1));
		assertAtom(-1, r.ceil(-1.5));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("X").ceil());
		assertAtom(1, r.round(1));
		assertAtom(1, r.expr(1).round());
		assertAtom(1, r.round(0.5));
		assertAtom(-1, r.round(-0.5));
		assertAtom(0, r.round(0));
		assertAtom(1, r.round(1));
		assertAtom(10, r.round(10));
		assertAtom(1000000000, r.round(1000000000));
		assertAtom(1e+20, r.round(1e+20));
		assertAtom(-1, r.round(-1));
		assertAtom(-10, r.round(-10));
		assertAtom(-1000000000, r.round(-1000000000));
		assertAtom(-1e+20, r.round(-1e+20));
		assertAtom(0, r.round(0.1));
		assertAtom(1, r.round(1.1));
		assertAtom(10, r.round(10.1));
		assertAtom(1000000000, r.round(1000000000.1));
		assertAtom(-1, r.round(-1.1));
		assertAtom(-10, r.round(-10.1));
		assertAtom(-1000000000, r.round(-1000000000.1));
		assertAtom(1, r.round(0.9));
		assertAtom(10, r.round(9.9));
		assertAtom(1000000000, r.round(999999999.9));
		assertAtom(-1, r.round(-0.9));
		assertAtom(-10, r.round(-9.9));
		assertAtom(-1000000000, r.round(-999999999.9));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.expr("X").round());
	}
}