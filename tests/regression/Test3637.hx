package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test3637 extends TestBase {
	override function test() {
		assertAtom(partial({ inserted : 2 }), tbl.insert([{ id : 0, value : "abc" }, { id : [1, -0], value : "def" }]));
		assertAtom({ id : 0 }, tbl.get(0).pluck("id").toJsonString());
		assertAtom({ id : 0 }, tbl.get(-0).pluck("id").toJsonString());
		assertAtom({ id : [1, -0] }, tbl.get([1, 0]).pluck("id").toJsonString());
		assertAtom({ id : [1, -0] }, tbl.get([1, -0]).pluck("id").toJsonString());
	}
}