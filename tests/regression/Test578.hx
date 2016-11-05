package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test578 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom({ "created" : 1 }, tbl.indexCreate("578", function(rec) return 1));
			@:await assertAtom([{ "ready" : true, "index" : "578" }], tbl.indexWait("578").pluck("index", "ready"));
			@:await assertErrorRegex("ReqlOpFailedError", "Index `578` already exists on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", tbl.indexCreate("578", function(rec) return 1));
			@:await assertAtom({ "dropped" : 1 }, tbl.indexDrop("578"));
			@:await assertErrorRegex("ReqlOpFailedError", "Index `578` does not exist on table `[a-zA-Z0-9_]+.[a-zA-Z0-9_]+`[.]", tbl.indexDrop("578"));
		};
		return Noise;
	}
}