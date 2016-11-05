package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test579 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertError("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic.", tbl.indexCreate("579", function(rec) return r.js("1")));
			@:await assertError("ReqlQueryLogicError", "Could not prove function deterministic.  Index functions must be deterministic.", tbl.indexCreate("579", function(rec) return tbl.get(0)));
		};
		return Noise;
	}
}