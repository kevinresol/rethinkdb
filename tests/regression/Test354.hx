package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test354 extends TestBase {
	@:async
	override function test() {
		var arr = r.expr([1, 2, 3, 4, 5]);
		@:await assertAtom([3, 4, 5], arr.skip(2));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", [1]), arr.skip("a"));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", [1]), arr.skip([1, 2, 3]));
		@:await assertError(err("ReqlQueryLogicError", "Expected type NUMBER but found OBJECT.", [0, 1]), arr.skip({  }).count());
		@:await assertError(err("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", [1]), arr.skip(null));
		return Noise;
	}
}