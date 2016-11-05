package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test2710 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom({ "a" : { "b" : 2 } }, r.expr({ "a" : { "b" : 1, "c" : 2 } }).merge(r.json("{\"a\":{\"$reql_type$\":\"LITERAL\", \"value\":{\"b\":2}}}")));
		};
		return Noise;
	}
}