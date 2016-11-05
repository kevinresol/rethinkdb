package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test4132 extends TestBase {
	@:async
	override function test() {
		{
			var _tables = ["tbl"];
			@:await createTables(_tables);
			var tbl = r.db("test").table("tbl");
			@:await assertAtom(true, r.and());
			@:await assertAtom(false, r.or());
			@:await assertAtom("nil", r.expr(false).or(nil));
			@:await dropTables(_tables);
		};
		return Noise;
	}
}