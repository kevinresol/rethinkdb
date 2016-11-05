package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestAtomic_get_set extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom({ "first_error" : "a", "changes" : [{ "old_val" : { "id" : 0, "x" : 2 }, "new_val" : { "id" : 0, "x" : 2 }, "error" : "a" }] }, tbl.get(0).replace(function(y) return { "x" : r.error("a") }, { "return_changes" : "always" }).pluck("changes", "first_error"));
		@:await dropTables(_tables);
		return Noise;
	}
}