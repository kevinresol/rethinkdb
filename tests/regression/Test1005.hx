package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class Test1005 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom("r.table_list()", r.expr(str(r.tableList())));
			@:await assertAtom("r.table_create(\'a\')", r.expr(str(r.tableCreate("a"))));
			@:await assertAtom("r.table_drop(\'a\')", r.expr(str(r.tableDrop("a"))));
			@:await assertAtom("r.db(\'a\').table_list()", r.expr(str(r.db("a").tableList())));
			@:await assertAtom("r.db(\'a\').table_create(\'a\')", r.expr(str(r.db("a").tableCreate("a"))));
			@:await assertAtom("r.db(\'a\').table_drop(\'a\')", r.expr(str(r.db("a").tableDrop("a"))));
		};
		return Noise;
	}
}