package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestDelete extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(100, tbl.count());
			@:await assertAtom({ "deleted" : 1, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }, tbl.get(12).delete());
			@:await assertError("ReqlQueryLogicError", "Durability option `wrong` unrecognized (options are \"hard\" and \"soft\").", tbl.skip(50).delete({ "durability" : "wrong" }));
			@:await assertAtom({ "deleted" : 49, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }, tbl.skip(50).delete({ "durability" : "soft" }));
			@:await assertAtom({ "deleted" : 50, "replaced" : 0, "unchanged" : 0, "errors" : 0, "skipped" : 0, "inserted" : 0 }, tbl.delete({ "durability" : "hard" }));
			@:await assertError("ReqlQueryLogicError", "Expected type SELECTION but found DATUM:", r.expr([1, 2]).delete());
		};
		return Noise;
	}
}