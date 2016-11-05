package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestArray extends TestBase {
	@:async
	override function test() {
		@:await assertAtom([], r.expr([]));
		@:await assertAtom([1], r.expr([1]));
		@:await assertAtom([1, 2, 3, 4, 5], r.expr([1, 2, 3, 4, 5]));
		@:await assertAtom("ARRAY", r.expr([]).typeOf());
		@:await assertAtom("[1,2]", r.expr([1, 2]).coerceTo("string"));
		@:await assertAtom("[1,2]", r.expr([1, 2]).coerceTo("STRING"));
		@:await assertAtom([1, 2], r.expr([1, 2]).coerceTo("array"));
		@:await assertError("ReqlQueryLogicError", "Cannot coerce ARRAY to NUMBER.", r.expr([1, 2]).coerceTo("number"));
		@:await assertAtom({ "a" : 1, "b" : 2 }, r.expr([["a", 1], ["b", 2]]).coerceTo("object"));
		@:await assertError("ReqlQueryLogicError", "Expected array of size 2, but got size 0.", r.expr([[]]).coerceTo("object"));
		@:await assertError("ReqlQueryLogicError", "Expected array of size 2, but got size 3.", r.expr([["1", 2, 3]]).coerceTo("object"));
		@:await assertAtom([1], r.expr([r.expr(1)]));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 3, 4]).insertAt(1, 2));
		@:await assertAtom([1, 2, 3], r.expr([2, 3]).insertAt(0, 1));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 2, 3]).insertAt(-1, 4));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 2, 3]).insertAt(3, 4));
		@:await assertError("ReqlNonExistenceError", "Index `4` out of bounds for array of size: `3`.", r.expr([1, 2, 3]).insertAt(4, 5));
		@:await assertError("ReqlNonExistenceError", "Index out of bounds: -5", r.expr([1, 2, 3]).insertAt(-5, -1));
		@:await assertError("ReqlQueryLogicError", "Number not an integer: 1.5", r.expr([1, 2, 3]).insertAt(1.5, 1));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", r.expr([1, 2, 3]).insertAt(null, 1));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 4]).spliceAt(1, [2, 3]));
		@:await assertAtom([1, 2, 3, 4], r.expr([3, 4]).spliceAt(0, [1, 2]));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 2]).spliceAt(2, [3, 4]));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 2]).spliceAt(-1, [3, 4]));
		@:await assertError("ReqlNonExistenceError", "Index `3` out of bounds for array of size: `2`.", r.expr([1, 2]).spliceAt(3, [3, 4]));
		@:await assertError("ReqlNonExistenceError", "Index out of bounds: -4", r.expr([1, 2]).spliceAt(-4, [3, 4]));
		@:await assertError("ReqlQueryLogicError", "Number not an integer: 1.5", r.expr([1, 2, 3]).spliceAt(1.5, [1]));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", r.expr([1, 2, 3]).spliceAt(null, [1]));
		@:await assertError("ReqlQueryLogicError", "Expected type ARRAY but found NUMBER.", r.expr([1, 4]).spliceAt(1, 2));
		@:await assertAtom([2, 3, 4], r.expr([1, 2, 3, 4]).deleteAt(0));
		@:await assertAtom([1, 2, 3], r.expr([1, 2, 3, 4]).deleteAt(-1));
		@:await assertAtom([1, 4], r.expr([1, 2, 3, 4]).deleteAt(1, 3));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 2, 3, 4]).deleteAt(4, 4));
		@:await assertAtom([], r.expr([]).deleteAt(0, 0));
		@:await assertAtom([1, 4], r.expr([1, 2, 3, 4]).deleteAt(1, -1));
		@:await assertError("ReqlNonExistenceError", "Index `4` out of bounds for array of size: `4`.", r.expr([1, 2, 3, 4]).deleteAt(4));
		@:await assertError("ReqlNonExistenceError", "Index out of bounds: -5", r.expr([1, 2, 3, 4]).deleteAt(-5));
		@:await assertError("ReqlQueryLogicError", "Number not an integer: 1.5", r.expr([1, 2, 3]).deleteAt(1.5));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", r.expr([1, 2, 3]).deleteAt(null));
		@:await assertAtom([1, 2, 3], r.expr([0, 2, 3]).changeAt(0, 1));
		@:await assertAtom([1, 2, 3], r.expr([1, 0, 3]).changeAt(1, 2));
		@:await assertAtom([1, 2, 3], r.expr([1, 2, 0]).changeAt(2, 3));
		@:await assertError("ReqlNonExistenceError", "Index `3` out of bounds for array of size: `3`.", r.expr([1, 2, 3]).changeAt(3, 4));
		@:await assertError("ReqlNonExistenceError", "Index out of bounds: -5", r.expr([1, 2, 3, 4]).changeAt(-5, 1));
		@:await assertError("ReqlQueryLogicError", "Number not an integer: 1.5", r.expr([1, 2, 3]).changeAt(1.5, 1));
		@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", r.expr([1, 2, 3]).changeAt(null, 1));
		return Noise;
	}
}