package meta;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDbs extends TestBase {
	@:async
	override function test() {
		@:await assertBag(["rethinkdb", "test"], r.dbList());
		@:await assertPartial({ "dbs_created" : 1 }, r.dbCreate("a"));
		@:await assertPartial({ "dbs_created" : 1 }, r.dbCreate("b"));
		// @:await assertBag(["rethinkdb", "a", "b", "test"], r.dbList());
		@:await assertAtom({ "name" : "a", "id" : uuid() }, r.db("a").config());
		@:await assertPartial({ "dbs_dropped" : 1 }, r.dbDrop("b"));
		// @:await assertBag(["rethinkdb", "a", "test"], r.dbList());
		@:await assertPartial({ "dbs_dropped" : 1 }, r.dbDrop("a"));
		@:await assertBag(["rethinkdb", "test"], r.dbList());
		@:await assertPartial({ "dbs_created" : 1 }, r.dbCreate("bar"));
		@:await assertError("ReqlOpFailedError", "Database `bar` already exists.", r.dbCreate("bar"));
		@:await assertPartial({ "dbs_dropped" : 1 }, r.dbDrop("bar"));
		@:await assertError("ReqlOpFailedError", "Database `bar` does not exist.", r.dbDrop("bar"));
		return Noise;
	}
}