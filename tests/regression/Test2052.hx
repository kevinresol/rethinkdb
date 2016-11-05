package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class Test2052 extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(1, r.expr(1));
			@:await assertError("ReqlCompileError", "Unrecognized global optional argument `obviously_bogus`.", r.expr(1));
		};
		return Noise;
	}
}