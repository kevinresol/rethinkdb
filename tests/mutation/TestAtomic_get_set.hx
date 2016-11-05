package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class TestAtomic_get_set extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom({ "first_error" : "a", "changes" : [{ "old_val" : { "id" : 0, "x" : 2 }, "new_val" : { "id" : 0, "x" : 2 }, "error" : "a" }] }, tbl.get(0).replace(function(y) return { "x" : r.error("a") }, { "return_changes" : "always" }).pluck("changes", "first_error"));
		};
		return Noise;
	}
}