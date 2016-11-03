package sindex;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestNullsinstrings extends TestBase {
	override function test() {
		assertAtom(({ created : 1 }), tbl.indexCreate("key"));
		assertAtom(([{ ready : true }]), tbl.indexWait().pluck("ready"));
		assertAtom(({ inserted : 2 }), tbl.insert([{ id : 1, key : ["a", "b"] }, { id : 2, key : ["a\u0000Sb"] }]).pluck("inserted"));
		assertAtom(([{ id : 2 }]), tbl.getAll(["a\u0000Sb"], { index : "key" }).pluck("id"));
		assertAtom(([{ id : 1 }]), tbl.getAll(["a", "b"], { index : "key" }).pluck("id"));
	}
}