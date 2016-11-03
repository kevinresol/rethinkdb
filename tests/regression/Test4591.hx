package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test4591 extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "r.args is not supported in an order_by or union command yet.", r.expr([{ x : 2 }, { x : 1 }]).orderBy(r.args(["x", "y"])));
	}
}