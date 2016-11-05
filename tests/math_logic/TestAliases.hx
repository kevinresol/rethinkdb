package math_logic;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestAliases extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(1, r.expr(0).add(1));
		@:await assertAtom(1, r.add(0, 1));
		@:await assertAtom(1, r.expr(2).sub(1));
		@:await assertAtom(1, r.sub(2, 1));
		@:await assertAtom(1, r.expr(2).div(2));
		@:await assertAtom(1, r.div(2, 2));
		@:await assertAtom(1, r.expr(1).mul(1));
		@:await assertAtom(1, r.mul(1, 1));
		@:await assertAtom(1, r.expr(1).mod(2));
		@:await assertAtom(1, r.mod(1, 2));
		@:await assertAtom(true, r.expr(true).and(true));
		@:await assertAtom(true, r.expr(true).or(true));
		@:await assertAtom(true, r.and(true, true));
		@:await assertAtom(true, r.or(true, true));
		@:await assertAtom(true, r.expr(false).not());
		@:await assertAtom(true, r.not(false));
		@:await assertAtom(true, r.expr(1).eq(1));
		@:await assertAtom(true, r.expr(1).ne(2));
		@:await assertAtom(true, r.expr(1).lt(2));
		@:await assertAtom(true, r.expr(1).gt(0));
		@:await assertAtom(true, r.expr(1).le(1));
		@:await assertAtom(true, r.expr(1).ge(1));
		@:await assertAtom(true, r.eq(1, 1));
		@:await assertAtom(true, r.ne(1, 2));
		@:await assertAtom(true, r.lt(1, 2));
		@:await assertAtom(true, r.gt(1, 0));
		@:await assertAtom(true, r.le(1, 1));
		@:await assertAtom(true, r.ge(1, 1));
		return Noise;
	}
}