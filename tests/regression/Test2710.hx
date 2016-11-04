package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2710 extends TestBase {
	override function test() {
		assertAtom({ "a" : { "b" : 2 } }, r.expr({ "a" : { "b" : 1, "c" : 2 } }).merge(r.json("{\"a\":{\"$reql_type$\":\"LITERAL\", \"value\":{\"b\":2}}}")));
	}
}