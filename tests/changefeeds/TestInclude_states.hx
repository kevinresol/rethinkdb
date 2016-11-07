package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestInclude_states extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom([{ "state" : "ready" }], tbl.changes({ "squash" : true, "include_states" : true }).limit(1));
		@:await assertAtom([{ "state" : "initializing" }, { "new_val" : null }, { "state" : "ready" }], tbl.get(0).changes({ "squash" : true, "include_states" : true, "include_initial" : true }).limit(3));
		@:await assertAtom([{ "state" : "initializing" }, { "state" : "ready" }], tbl.orderBy({ "index" : "id" }).limit(10).changes({ "squash" : true, "include_states" : true, "include_initial" : true }).limit(2));
		tbl.insert({ "id" : 1 });
		@:await assertAtom([{ "state" : "initializing" }, { "new_val" : { "id" : 1 } }, { "state" : "ready" }], tbl.orderBy({ "index" : "id" }).limit(10).changes({ "squash" : true, "include_states" : true, "include_initial" : true }).limit(3));
		var tblchanges = tbl.changes({ "squash" : true, "include_states" : true });
		tbl.insert({ "id" : 2 });
		@:await assertAtom([{ "state" : "ready" }, { "new_val" : { "id" : 2 }, "old_val" : null }], fetch(tblchanges, 2));
		var getchanges = tbl.get(2).changes({ "include_states" : true, "include_initial" : true });
		tbl.get(2).update({ "a" : 1 });
		@:await assertAtom([{ "state" : "initializing" }, { "new_val" : { "id" : 2 } }, { "state" : "ready" }, { "old_val" : { "id" : 2 }, "new_val" : { "id" : 2, "a" : 1 } }], fetch(getchanges, 4));
		var limitchanges = tbl.orderBy({ "index" : "id" }).limit(10).changes({ "include_states" : true, "include_initial" : true });
		var limitchangesdesc = tbl.orderBy({ "index" : r.desc("id") }).limit(10).changes({ "include_states" : true, "include_initial" : true });
		tbl.insert({ "id" : 3 });
		@:await assertAtom([{ "state" : "initializing" }, { "new_val" : { "id" : 1 } }, { "new_val" : { "a" : 1, "id" : 2 } }, { "state" : "ready" }, { "old_val" : null, "new_val" : { "id" : 3 } }], fetch(limitchanges, 5));
		@:await assertAtom([{ "state" : "initializing" }, { "new_val" : { "a" : 1, "id" : 2 } }, { "new_val" : { "id" : 1 } }, { "state" : "ready" }, { "old_val" : null, "new_val" : { "id" : 3 } }], fetch(limitchangesdesc, 5));
		@:await dropTables(_tables);
		return Noise;
	}
}