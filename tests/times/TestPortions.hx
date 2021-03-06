package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestPortions extends TestBase {
	@:async
	override function test() {
		var rt1 = 1375147296.681;
		var rt2 = 1375147296.682;
		var rt3 = 1375147297.681;
		var rt4 = 2375147296.681;
		var rts = ([rt1, rt2, rt3, rt4] : Array<Dynamic>);
		var t1 = r.epochTime(rt1);
		var t2 = r.epochTime(rt2);
		var t3 = r.epochTime(rt3);
		var t4 = r.epochTime(rt4);
		var ts = r.expr(([t1, t2, t3, t4] : Array<Dynamic>));
		@:await assertAtom((([1375142400, 1375142400, 1375142400, 2375136000] : Array<Dynamic>)), ts.map(function(x:Expr):Expr return x.date()).map(function(x:Expr):Expr return x.toEpochTime()));
		@:await assertAtom((([0, 0, 0, 0] : Array<Dynamic>)), ts.map(function(x:Expr):Expr return x.date().timeOfDay()));
		@:await assertAtom((([4896.681, 4896.682, 4897.681, 11296.681] : Array<Dynamic>)), ts.map(function(x:Expr):Expr return x.timeOfDay()));
		@:await assertAtom((([([2013, 7, 30, 1, 21, 36.681] : Array<Dynamic>), ([2013, 7, 30, 1, 21, 36.682] : Array<Dynamic>), ([2013, 7, 30, 1, 21, 37.681] : Array<Dynamic>), ([2045, 4, 7, 3, 8, 16.681] : Array<Dynamic>)] : Array<Dynamic>)), ts.map(function(x:Expr):Expr return ([x.year(), x.month(), x.day(), x.hours(), x.minutes(), x.seconds()] : Array<Dynamic>)));
		@:await assertAtom(rts, ts.map(function(x:Expr):Expr return r.time(x.year(), x.month(), x.day(), x.hours(), x.minutes(), x.seconds(), x.timezone())).map(function(x:Expr):Expr return x.toEpochTime()));
		@:await assertAtom(0, ts.map(function(x:Expr):Expr return r.time(x.year(), x.month(), x.day(), x.hours(), x.minutes(), x.seconds(), x.timezone())).union(ts).map(function(x:Expr):Expr return x.toIso8601()).distinct().count().sub(ts.count()));
		@:await assertAtom(([([2, 211] : Array<Dynamic>), ([2, 211] : Array<Dynamic>), ([2, 211] : Array<Dynamic>), ([5, 97] : Array<Dynamic>)] : Array<Dynamic>), ts.map(([r.row.dayOfWeek(), r.row.dayOfYear()] : Array<Dynamic>)));
		return Noise;
	}
}