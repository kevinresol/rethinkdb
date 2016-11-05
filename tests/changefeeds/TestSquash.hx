package changefeeds;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestSquash extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		@:await assertAtom("STREAM", tbl.changes({ "squash" : true }).typeOf());
		@:await assertAtom(1, tbl.insert({ "id" : 100 })["inserted"]);
		@:await assertAtom(1, tbl.get(100).update({ "a" : 1 })["replaced"]);
		@:await assertAtom([{ "new_val" : { "id" : 100 }, "old_val" : null }, { "new_val" : { "a" : 1, "id" : 100 }, "old_val" : { "id" : 100 } }], normal_changes);
		@:await assertAtom([{ "new_val" : { "id" : 100 }, "old_val" : null }, { "new_val" : { "a" : 1, "id" : 100 }, "old_val" : { "id" : 100 } }], false_squash_changes);
		@:await assertAtom([{ "new_val" : { "a" : 1, "id" : 100 }, "old_val" : null }], long_squash_changes);
		@:await assertAtom([{ "new_val" : { "id" : 100 }, "old_val" : null }], squash_changes);
		@:await assertError("ReqlQueryLogicError", "Expected BOOL or NUMBER but found NULL.", tbl.changes({ "squash" : null }));
		@:await assertError("ReqlQueryLogicError", "Expected BOOL or a positive NUMBER but found a negative NUMBER.", tbl.changes({ "squash" : -10 }));
		@:await dropTables(_tables);
		return Noise;
	}
}