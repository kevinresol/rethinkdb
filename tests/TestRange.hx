package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestRange extends TestBase {
	override function test() {
		assertAtom([0, 1, 2, 3], r.range().limit(4));
		assertAtom([0, 1, 2, 3], r.range(4));
		assertAtom([2, 3, 4], r.range(2, 5));
		assertAtom([], r.range(0));
		assertAtom([], r.range(5, 2));
		assertAtom([-5, -4, -3], r.range(-5, -2));
		assertAtom([-5, -4, -3, -2, -1, 0, 1], r.range(-5, 2));
		assertError("ReqlCompileError", "Expected between 0 and 2 arguments but found 3.", r.range(2, 5, 8));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", r.range("foo"));
		assertAtom(err_regex("ReqlQueryLogicError", "Number not an integer \\(>2\\^53\\). 9007199254740994", []), r.range(9007199254740994));
		assertAtom(err_regex("ReqlQueryLogicError", "Number not an integer \\(<-2\\^53\\). -9007199254740994", []), r.range(-9007199254740994));
		assertAtom(err_regex("ReqlQueryLogicError", "Number not an integer. 0\\.5", []), r.range(0.5));
		assertError("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", r.range().count());
		assertError("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", r.range().coerceTo("ARRAY"));
		assertError("ReqlQueryLogicError", "Cannot use an infinite stream with an aggregation function (`reduce`, `count`, etc.) or coerce it to an array.", r.range().coerceTo("OBJECT"));
		assertAtom(4, r.range(4).count());
	}
}