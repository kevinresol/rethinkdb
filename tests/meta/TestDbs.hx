package meta;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDbs extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(bag(["rethinkdb", "test"]), r.dbList());
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("a"));
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("b"));
		@:await assertAtom(bag(["rethinkdb", "a", "b", "test"]), r.dbList());
		@:await assertAtom({ "name" : "a", "id" : uuid() }, r.db("a").config());
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("b"));
		@:await assertAtom(bag(["rethinkdb", "a", "test"]), r.dbList());
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("a"));
		@:await assertAtom(bag(["rethinkdb", "test"]), r.dbList());
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("bar"));
		@:await assertError("ReqlOpFailedError", "Database `bar` already exists.", r.dbCreate("bar"));
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("bar"));
		@:await assertError("ReqlOpFailedError", "Database `bar` does not exist.", r.dbDrop("bar"));
		return Noise;
	}
}