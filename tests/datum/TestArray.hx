package datum;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestArray extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(([] : Array<Dynamic>), r.expr(([] : Array<Dynamic>)));
		@:await assertAtom(([1] : Array<Dynamic>), r.expr(([1] : Array<Dynamic>)));
		@:await assertAtom(([1, 2, 3, 4, 5] : Array<Dynamic>), r.expr(([1, 2, 3, 4, 5] : Array<Dynamic>)));
		@:await assertAtom("ARRAY", r.expr(([] : Array<Dynamic>)).typeOf());
		@:await assertAtom("[1,2]", r.expr(([1, 2] : Array<Dynamic>)).coerceTo("string"));
		@:await assertAtom("[1,2]", r.expr(([1, 2] : Array<Dynamic>)).coerceTo("STRING"));
		@:await assertAtom(([1, 2] : Array<Dynamic>), r.expr(([1, 2] : Array<Dynamic>)).coerceTo("array"));
		@:await assertError(err("ReqlQueryLogicError", "Cannot coerce ARRAY to NUMBER.", ([0] : Array<Dynamic>)), r.expr(([1, 2] : Array<Dynamic>)).coerceTo("number"));
		@:await assertAtom({ "a" : 1, "b" : 2 }, r.expr(([(["a", 1] : Array<Dynamic>), (["b", 2] : Array<Dynamic>)] : Array<Dynamic>)).coerceTo("object"));
		@:await assertError(err("ReqlQueryLogicError", "Expected array of size 2, but got size 0."), r.expr(([([] : Array<Dynamic>)] : Array<Dynamic>)).coerceTo("object"));
		@:await assertError(err("ReqlQueryLogicError", "Expected array of size 2, but got size 3."), r.expr(([(["1", 2, 3] : Array<Dynamic>)] : Array<Dynamic>)).coerceTo("object"));
		@:await assertAtom(([1] : Array<Dynamic>), r.expr(([r.expr(1)] : Array<Dynamic>)));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 3, 4] : Array<Dynamic>)).insertAt(1, 2));
		@:await assertAtom(([1, 2, 3] : Array<Dynamic>), r.expr(([2, 3] : Array<Dynamic>)).insertAt(0, 1));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(-1, 4));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(3, 4));
		r.expr(3).do_(function(x:Expr):Expr return r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(x, 4));
		@:await assertError(err("ReqlNonExistenceError", "Index `4` out of bounds for array of size: `3`.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(4, 5));
		@:await assertError(err("ReqlNonExistenceError", "Index out of bounds: -5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(-5, -1));
		@:await assertError(err("ReqlQueryLogicError", "Number not an integer: 1.5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(1.5, 1));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).insertAt(null, 1));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 4] : Array<Dynamic>)).spliceAt(1, ([2, 3] : Array<Dynamic>)));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([3, 4] : Array<Dynamic>)).spliceAt(0, ([1, 2] : Array<Dynamic>)));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 2] : Array<Dynamic>)).spliceAt(2, ([3, 4] : Array<Dynamic>)));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 2] : Array<Dynamic>)).spliceAt(-1, ([3, 4] : Array<Dynamic>)));
		r.expr(2).do_(function(x:Expr):Expr return r.expr(([1, 2] : Array<Dynamic>)).spliceAt(x, ([3, 4] : Array<Dynamic>)));
		@:await assertError(err("ReqlNonExistenceError", "Index `3` out of bounds for array of size: `2`.", ([0] : Array<Dynamic>)), r.expr(([1, 2] : Array<Dynamic>)).spliceAt(3, ([3, 4] : Array<Dynamic>)));
		@:await assertError(err("ReqlNonExistenceError", "Index out of bounds: -4", ([0] : Array<Dynamic>)), r.expr(([1, 2] : Array<Dynamic>)).spliceAt(-4, ([3, 4] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Number not an integer: 1.5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).spliceAt(1.5, ([1] : Array<Dynamic>)));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).spliceAt(null, ([1] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Expected type ARRAY but found NUMBER.", ([0] : Array<Dynamic>)), r.expr(([1, 4] : Array<Dynamic>)).spliceAt(1, 2));
		@:await assertAtom(([2, 3, 4] : Array<Dynamic>), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(0));
		r.expr(0).do_(function(x:Expr):Expr return r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(x));
		@:await assertAtom(([1, 2, 3] : Array<Dynamic>), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(-1));
		@:await assertAtom(([1, 4] : Array<Dynamic>), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(1, 3));
		@:await assertAtom(([1, 2, 3, 4] : Array<Dynamic>), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(4, 4));
		@:await assertAtom(([] : Array<Dynamic>), r.expr(([] : Array<Dynamic>)).deleteAt(0, 0));
		@:await assertAtom(([1, 4] : Array<Dynamic>), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(1, -1));
		@:await assertError(err("ReqlNonExistenceError", "Index `4` out of bounds for array of size: `4`.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(4));
		@:await assertError(err("ReqlNonExistenceError", "Index out of bounds: -5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).deleteAt(-5));
		@:await assertError(err("ReqlQueryLogicError", "Number not an integer: 1.5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).deleteAt(1.5));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).deleteAt(null));
		@:await assertAtom(([1, 2, 3] : Array<Dynamic>), r.expr(([0, 2, 3] : Array<Dynamic>)).changeAt(0, 1));
		r.expr(1).do_(function(x:Expr):Expr return r.expr(([0, 2, 3] : Array<Dynamic>)).changeAt(0, x));
		@:await assertAtom(([1, 2, 3] : Array<Dynamic>), r.expr(([1, 0, 3] : Array<Dynamic>)).changeAt(1, 2));
		@:await assertAtom(([1, 2, 3] : Array<Dynamic>), r.expr(([1, 2, 0] : Array<Dynamic>)).changeAt(2, 3));
		@:await assertError(err("ReqlNonExistenceError", "Index `3` out of bounds for array of size: `3`.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).changeAt(3, 4));
		@:await assertError(err("ReqlNonExistenceError", "Index out of bounds: -5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3, 4] : Array<Dynamic>)).changeAt(-5, 1));
		@:await assertError(err("ReqlQueryLogicError", "Number not an integer: 1.5", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).changeAt(1.5, 1));
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", ([0] : Array<Dynamic>)), r.expr(([1, 2, 3] : Array<Dynamic>)).changeAt(null, 1));
		return Noise;
	}
}