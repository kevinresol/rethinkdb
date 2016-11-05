package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test4501 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertErrorRegex("ReqlOpFailedError", "Index `missing` was not found on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", tbl.indexWait("missing"));
		};
		return Noise;
	}
}