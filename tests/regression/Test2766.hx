package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test2766 extends TestBase {
	@:async
	override function test() {
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `bracket` on objects of type `PTYPE<TIME>`."), r.now()["epoch_time"]);
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `get_field` on objects of type `PTYPE<TIME>`."), r.now().getField("epoch_time"));
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `keys` on objects of type `PTYPE<TIME>`."), r.now().keys());
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `pluck` on objects of type `PTYPE<TIME>`."), r.now().pluck("epoch_time"));
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `without` on objects of type `PTYPE<TIME>`."), r.now().without("epoch_time"));
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `merge` on objects of type `PTYPE<TIME>`."), r.now().merge({ "foo" : 4 }));
		@:await assertError(err("ReqlQueryLogicError", "Cannot merge objects of type `PTYPE<TIME>`."), r.expr({ "foo" : 4 }).merge(r.now()));
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `has_fields` on objects of type `PTYPE<TIME>`."), r.now().hasFields("epoch_time"));
		@:await assertError(err("ReqlQueryLogicError", "Invalid path argument `1404691200`."), r.object().hasFields(r.time(2014, 7, 7, "Z")));
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `keys` on objects of type `NUMBER`."), r.expr(1).keys());
		return Noise;
	}
}