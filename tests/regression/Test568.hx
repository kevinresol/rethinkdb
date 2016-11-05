package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test568 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "Cannot convert STRING to SEQUENCE", tbl.concatMap(function(rec) return rec["name"]));
		};
		return Noise;
	}
}