package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class Test3057 extends TestBase {
	@:async
	override function test() {
		@:await assertAtom((false), r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>)).polygonSub(r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>))).intersects(r.point(0, 0)));
		@:await assertAtom((false), r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>)).polygonSub(r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>))).intersects(r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>))));
		@:await assertAtom((false), r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>)).polygonSub(r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>))).intersects(r.line(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>))));
		@:await assertAtom((false), r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>)).intersects(r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>)).polygonSub(r.polygon(([0, 0] : Array<Dynamic>), ([0, 10] : Array<Dynamic>), ([10, 10] : Array<Dynamic>), ([10, 0] : Array<Dynamic>)))));
		return Noise;
	}
}