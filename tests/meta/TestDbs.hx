package meta;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestDbs extends TestBase {
	override function test() {
		assertAtom("bag([\'rethinkdb\', \'test\'])", r.dbList());
		assertAtom("partial({\'dbs_created\':1})", r.dbCreate("a"));
		assertAtom("partial({\'dbs_created\':1})", r.dbCreate("b"));
		assertAtom("bag([\'rethinkdb\', \'a\', \'b\', \'test\'])", r.dbList());
		assertAtom({ "name" : "a", "id" : "uuid()" }, r.db("a").config());
		assertAtom("partial({\'dbs_dropped\':1})", r.dbDrop("b"));
		assertAtom("bag([\'rethinkdb\', \'a\', \'test\'])", r.dbList());
		assertAtom("partial({\'dbs_dropped\':1})", r.dbDrop("a"));
		assertAtom("bag([\'rethinkdb\', \'test\'])", r.dbList());
		assertAtom("partial({\'dbs_created\':1})", r.dbCreate("bar"));
		assertError("ReqlOpFailedError", "Database `bar` already exists.", r.dbCreate("bar"));
		assertAtom("partial({\'dbs_dropped\':1})", r.dbDrop("bar"));
		assertError("ReqlOpFailedError", "Database `bar` does not exist.", r.dbDrop("bar"));
	}
}