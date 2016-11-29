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
		@:await assertAtom(("STREAM"), tbl.changes({ "squash" : true }).typeOf());
		var normal_changes = tbl.changes().limit(2);
		var false_squash_changes = tbl.changes({ "squash" : false }).limit(2);
		var long_squash_changes = tbl.changes({ "squash" : 0.5 }).limit(1);
		var squash_changes = tbl.changes({ "squash" : true }).limit(1);
		@:await assertAtom(1, tbl.insert({ "id" : 100 })["inserted"]);
		@:await assertAtom(1, tbl.get(100).update({ "a" : 1 })["replaced"]);
		@:await assertAtom(([{ "new_val" : { "id" : 100 }, "old_val" : null }, { "new_val" : { "a" : 1, "id" : 100 }, "old_val" : { "id" : 100 } }] : Array<Dynamic>), normal_changes);
		@:await assertAtom(([{ "new_val" : { "id" : 100 }, "old_val" : null }, { "new_val" : { "a" : 1, "id" : 100 }, "old_val" : { "id" : 100 } }] : Array<Dynamic>), false_squash_changes);
		@:await assertAtom(([{ "new_val" : { "a" : 1, "id" : 100 }, "old_val" : null }] : Array<Dynamic>), long_squash_changes);
		@:await assertAtom(([{ "new_val" : { "id" : 100 }, "old_val" : null }] : Array<Dynamic>), squash_changes);
		@:await assertError(err("ReqlQueryLogicError", "Expected BOOL or NUMBER but found NULL."), tbl.changes({ "squash" : null }));
		@:await assertError(err("ReqlQueryLogicError", "Expected BOOL or a positive NUMBER but found a negative NUMBER."), tbl.changes({ "squash" : -10 }));
		@:await dropTables(_tables);
		return Noise;
	}
}