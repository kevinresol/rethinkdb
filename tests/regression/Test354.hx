package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test354 extends TestBase {
	@:async
	override function test() {
		{
			var arr = r.expr([1, 2, 3, 4, 5]);
			@:await assertAtom([3, 4, 5], arr.skip(2));
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", arr.skip("a"));
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", arr.skip([1, 2, 3]));
			@:await assertError("ReqlQueryLogicError", "Expected type NUMBER but found OBJECT.", arr.skip({  }).count());
			@:await assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", arr.skip(null));
		};
		return Noise;
	}
}