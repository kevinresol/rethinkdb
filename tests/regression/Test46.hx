package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test46 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertPartial({ "tables_created" : 1 }, r.tableCreate("46"));
			@:await assertAtom(["46"], r.tableList());
			@:await assertPartial({ "tables_dropped" : 1 }, r.tableDrop("46"));
		};
		return Noise;
	}
}