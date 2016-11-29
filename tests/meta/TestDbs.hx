package meta;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDbs extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(bag((["rethinkdb", "test"] : Array<Dynamic>)), r.dbList());
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("a"));
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("b"));
		@:await assertAtom(bag((["rethinkdb", "a", "b", "test"] : Array<Dynamic>)), r.dbList());
		@:await assertAtom({ "name" : "a", "id" : uuid() }, r.db("a").config());
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("b"));
		@:await assertAtom(bag((["rethinkdb", "a", "test"] : Array<Dynamic>)), r.dbList());
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("a"));
		@:await assertAtom(bag((["rethinkdb", "test"] : Array<Dynamic>)), r.dbList());
		@:await assertAtom(partial({ "dbs_created" : 1 }), r.dbCreate("bar"));
		@:await assertError(err("ReqlOpFailedError", "Database `bar` already exists.", ([0] : Array<Dynamic>)), r.dbCreate("bar"));
		@:await assertAtom(partial({ "dbs_dropped" : 1 }), r.dbDrop("bar"));
		@:await assertError(err("ReqlOpFailedError", "Database `bar` does not exist.", ([0] : Array<Dynamic>)), r.dbDrop("bar"));
		return Noise;
	}
}