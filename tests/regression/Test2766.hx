package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2766 extends TestBase {
	override function test() {
		assertError("ReqlQueryLogicError", "Cannot call `bracket` on objects of type `PTYPE<TIME>`.", r.now()["epoch_time"]);
		assertError("ReqlQueryLogicError", "Cannot call `get_field` on objects of type `PTYPE<TIME>`.", r.now().getField("epoch_time"));
		assertError("ReqlQueryLogicError", "Cannot call `keys` on objects of type `PTYPE<TIME>`.", r.now().keys());
		assertError("ReqlQueryLogicError", "Cannot call `pluck` on objects of type `PTYPE<TIME>`.", r.now().pluck("epoch_time"));
		assertError("ReqlQueryLogicError", "Cannot call `without` on objects of type `PTYPE<TIME>`.", r.now().without("epoch_time"));
		assertError("ReqlQueryLogicError", "Cannot call `merge` on objects of type `PTYPE<TIME>`.", r.now().merge({ "foo" : 4 }));
		assertError("ReqlQueryLogicError", "Cannot merge objects of type `PTYPE<TIME>`.", r.expr({ "foo" : 4 }).merge(r.now()));
		assertError("ReqlQueryLogicError", "Cannot call `has_fields` on objects of type `PTYPE<TIME>`.", r.now().hasFields("epoch_time"));
		assertError("ReqlQueryLogicError", "Invalid path argument `1404691200`.", r.object().hasFields(r.time(2014, 7, 7, "Z")));
		assertError("ReqlQueryLogicError", "Cannot call `keys` on objects of type `NUMBER`.", r.expr(1).keys());
	}
}