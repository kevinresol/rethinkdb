package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestRange extends TestBase {
	@:async
	override function test() {
		@:await assertAtom("STREAM", r.range().typeOf());
		@:await assertBag([0, 1, 2, 3], r.range().limit(4));
		@:await assertBag([0, 1, 2, 3], r.range(4));
		@:await assertBag([2, 3, 4], r.range(2, 5));
		@:await assertBag([], r.range(0));
		@:await assertBag([], r.range(5, 2));
		@:await assertBag([-5, -4, -3], r.range(-5, -2));
		@:await assertBag([-5, -4, -3, -2, -1, 0, 1], r.range(-5, 2));
		// @:await assertError("ReqlCompileError", "Expected between 0 and 2 arguments but found 3.", r.range(2, 5, 8));
		@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.range("foo"));
		@:await assertErrorRegex("ReqlQueryLogicError", "Number not an integer \\(>2\\^53\\). 9007199254740994", r.range(9007199254740994));
		@:await assertErrorRegex("ReqlQueryLogicError", "Number not an integer \\(<-2\\^53\\). -9007199254740994", r.range(-9007199254740994));
		@:await assertErrorRegex("ReqlQueryLogicError", "Number not an integer. 0\\.5", r.range(0.5));
		@:await assertError("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", r.range().count());
		@:await assertError("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", r.range().coerceTo("ARRAY"));
		@:await assertError("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", r.range().coerceTo("OBJECT"));
		@:await assertAtom(4, r.range(4).count());
		return Noise;
	}
}