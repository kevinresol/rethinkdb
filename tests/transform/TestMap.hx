package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestMap extends TestBase {
	@:async
	override function test() {
		@:await assertAtom("STREAM", r.range().map(r.range(), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)).typeOf());
		@:await assertAtom("STREAM", r.range().map(r.expr(([] : Array<Dynamic>)), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)).typeOf());
		@:await assertAtom("ARRAY", r.expr(([] : Array<Dynamic>)).map(r.expr(([] : Array<Dynamic>)), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)).typeOf());
		@:await assertAtom(([0, 0, 0] : Array<Dynamic>), r.range(3).map(function():Expr return 0));
		@:await assertAtom(([0, 0, 0] : Array<Dynamic>), r.range(3).map(r.range(4), function(x:Expr, y:Expr):Expr return 0));
		@:await assertAtom(([([1] : Array<Dynamic>)] : Array<Dynamic>), r.expr(([1] : Array<Dynamic>)).map());
		@:await assertAtom(([([1, 1] : Array<Dynamic>)] : Array<Dynamic>), r.expr(([1] : Array<Dynamic>)).map(r.expr(([1] : Array<Dynamic>)), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertAtom(([([1, 1, 1] : Array<Dynamic>)] : Array<Dynamic>), r.expr(([1] : Array<Dynamic>)).map(r.expr(([1] : Array<Dynamic>)), r.expr(([1] : Array<Dynamic>)), function(x:Expr, y:Expr, z:Expr):Expr return ([x, y, z] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "The function passed to `map` expects 2 arguments, but 1 sequence was found.", ([] : Array<Dynamic>)), r.expr(([1] : Array<Dynamic>)).map(function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertAtom(([] : Array<Dynamic>), r.range().map(r.expr(([] : Array<Dynamic>)), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertAtom(([([1, 1] : Array<Dynamic>), ([2, 2] : Array<Dynamic>)] : Array<Dynamic>), r.expr(([1, 2] : Array<Dynamic>)).map(r.expr(([1, 2, 3, 4] : Array<Dynamic>)), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertAtom(([([0, 0] : Array<Dynamic>), ([1, 1] : Array<Dynamic>)] : Array<Dynamic>), r.range(2).map(r.range(4), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertAtom(([([0, 1] : Array<Dynamic>), ([1, 2] : Array<Dynamic>), ([2, 3] : Array<Dynamic>), ([3, 4] : Array<Dynamic>)] : Array<Dynamic>), r.range().map(r.expr(([1, 2, 3, 4] : Array<Dynamic>)), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertAtom(([([0, 0] : Array<Dynamic>), ([1, 1] : Array<Dynamic>), ([2, 2] : Array<Dynamic>)] : Array<Dynamic>), r.range(3).map(r.range(5), r.js("(function(x, y){return [x, y];})")));
		@:await assertError(err("ReqlQueryLogicError", "Cannot convert NUMBER to SEQUENCE", ([] : Array<Dynamic>)), r.range().map(r.expr(1), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		@:await assertError(err("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", ([] : Array<Dynamic>)), r.range().map(r.range(), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)).count());
		@:await assertAtom(([1, 2, 3] : Array<Dynamic>), r.map(r.range(3), r.row + 1));
		@:await assertAtom(([([0, 0] : Array<Dynamic>), ([1, 1] : Array<Dynamic>), ([2, 2] : Array<Dynamic>)] : Array<Dynamic>), r.map(r.range(3), r.range(5), function(x:Expr, y:Expr):Expr return ([x, y] : Array<Dynamic>)));
		return Noise;
	}
}