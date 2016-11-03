package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test469 extends TestBase {
	override function test() {
		assertAtom(partial({ dbs_created : 1 }), r.dbCreate("d469"));
		assertAtom(partial({ tables_created : 1 }), r.db("d469").tableCreate("t469"));
		assertAtom(partial({ type : "DB", name : "d469" }), r.db("d469").info());
		assertAtom(partial({ dbs_dropped : 1 }), r.dbDrop("d469"));
	}
}