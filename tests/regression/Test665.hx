package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test665 extends TestBase {
	@:async
	override function test() {
		{
			var t = r.db("test").table("t665");
			@:await assertAtom({ "unchanged" : 0, "skipped" : 0, "replaced" : 0, "inserted" : 2, "errors" : 0, "deleted" : 0 }, t.insert([{ "id" : 1 }, { "id" : 4 }]));
		};
		return Noise;
	}
}