package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2767 extends TestBase {
	override function test() {
		assertAtom({ "created" : 1 }, tbl.indexCreate("foo", function(x) return (x["a"] + [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10]).count()));
		assertAtom({ "deleted" : 0, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 1 }, tbl.insert({ "id" : 1, "a" : [1, 2, 3, 4, 5] }));
		assertAtom([{ "id" : 1, "a" : [1, 2, 3, 4, 5] }], tbl.coerceTo("array"));
		assertAtom([{ "id" : 1, "a" : [1, 2, 3, 4, 5] }], tbl.getAll(15, { "index" : "foo" }).coerceTo("array"));
		assertAtom([{ "id" : 1, "a" : [1, 2, 3, 4, 5] }], tbl.getAll(15, { "index" : "foo" }).coerceTo("array"));
	}
}