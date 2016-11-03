package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestSquash extends TestBase {
	override function test() {
		assertAtom(("STREAM"), tbl.changes({ "squash" : true }).typeOf());
		assertAtom(null, normal_changes = tbl.changes().limit(2));
		assertAtom(null, long_squash_changes = tbl.changes({ "squash" : 0.5 }).limit(1));
		assertAtom(null, squash_changes = tbl.changes({ "squash" : true }).limit(1));
		assertAtom(1, tbl.insert({ id : 100 })["inserted"]);
		assertAtom(1, tbl.get(100).update({ a : 1 })["replaced"]);
		assertAtom(([{ new_val : { id : 100 }, old_val : null }, { new_val : { a : 1, id : 100 }, old_val : { id : 100 } }]), normal_changes);
		assertAtom(([{ new_val : { id : 100 }, old_val : null }, { new_val : { a : 1, id : 100 }, old_val : { id : 100 } }]), false_squash_changes);
		assertAtom(([{ new_val : { a : 1, id : 100 }, old_val : null }]), long_squash_changes);
		assertError("ReqlQueryLogicError", "Expected BOOL or NUMBER but found NULL.", tbl.changes({ "squash" : null }));
		assertError("ReqlQueryLogicError", "Expected BOOL or a positive NUMBER but found a negative NUMBER.", tbl.changes({ "squash" : -10 }));
	}
}