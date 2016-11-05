package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
@:await class TestMath extends TestBase {
	@:async
	override function test() {
		{
			@:await assertAtom(1, (((4 + 2 * (r.expr(26) % 18)) / 5) - 3));
		};
		return Noise;
	}
}