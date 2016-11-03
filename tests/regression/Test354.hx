package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test354 extends TestBase {
	override function test() {
		var arr = r.expr([1, 2, 3, 4, 5]);
		assertAtom([3, 4, 5], arr.skip(2));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found STRING.", arr.skip("a"));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found ARRAY.", arr.skip([1, 2, 3]));
		assertError("ReqlQueryLogicError", "Expected type NUMBER but found OBJECT.", arr.skip({  }).count());
		assertError("ReqlNonExistenceError", "Expected type NUMBER but found NULL.", arr.skip(null));
	}
}