package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestTimezones extends TestBase {
	@:async
	override function test() {
		var t1 = r.time(2013, r.july, 29, 23, 30, 0, "+00:00");
		var tutc1 = t1.inTimezone("Z");
		var tutc2 = t1.inTimezone("+00:00");
		var tutc3 = t1.inTimezone("+00");
		var tutcs = r.expr(([tutc1, tutc2, tutc3] : Array<Dynamic>));
		var tm1 = t1.inTimezone("-00:59");
		var tm2 = t1.inTimezone("-01:00");
		var tm3 = t1.inTimezone("-01:01");
		var tms = r.expr(([tm1, tm2, tm3] : Array<Dynamic>));
		var tp1 = t1.inTimezone("+00:59");
		var tp2 = t1.inTimezone("+01:00");
		var tp3 = t1.inTimezone("+01:01");
		var tps = r.expr(([tp1, tp2, tp3] : Array<Dynamic>));
		var ts = tutcs.union(tms).union(tps).union(([t1] : Array<Dynamic>));
		@:await assertAtom((([(["+00:00", 29] : Array<Dynamic>), (["+00:00", 29] : Array<Dynamic>), (["+00:00", 29] : Array<Dynamic>)] : Array<Dynamic>)), tutcs.map(function(x:Expr):Expr return ([x.timezone(), x.day()] : Array<Dynamic>)));
		@:await assertAtom((([(["-00:59", 29] : Array<Dynamic>), (["-01:00", 29] : Array<Dynamic>), (["-01:01", 29] : Array<Dynamic>)] : Array<Dynamic>)), tms.map(function(x:Expr):Expr return ([x.timezone(), x.day()] : Array<Dynamic>)));
		@:await assertAtom((([(["+00:59", 30] : Array<Dynamic>), (["+01:00", 30] : Array<Dynamic>), (["+01:01", 30] : Array<Dynamic>)] : Array<Dynamic>)), tps.map(function(x:Expr):Expr return ([x.timezone(), x.day()] : Array<Dynamic>)));
		@:await assertAtom((([0] : Array<Dynamic>)), ts.concatMap(function(x:Expr):Expr return ts.map(function(y:Expr):Expr return x - y)).distinct());
		@:await assertError(err("ReqlQueryLogicError", "Timezone `` does not start with `-` or `+`."), r.now().inTimezone(""));
		@:await assertError(err("ReqlQueryLogicError", "`-00` is not a valid time offset."), r.now().inTimezone("-00"));
		@:await assertError(err("ReqlQueryLogicError", "`-00:00` is not a valid time offset."), r.now().inTimezone("-00:00"));
		@:await assertError(err("ReqlQueryLogicError", "Timezone `UTC+00` does not start with `-` or `+`."), r.now().inTimezone("UTC+00"));
		@:await assertError(err("ReqlQueryLogicError", "Minutes out of range in `+00:60`."), r.now().inTimezone("+00:60"));
		@:await assertError(err("ReqlQueryLogicError", "Hours out of range in `+25:00`."), r.now().inTimezone("+25:00"));
		@:await assertError(err("ReqlQueryLogicError", "Timezone `` does not start with `-` or `+`."), r.time(2013, 1, 1, ""));
		@:await assertError(err("ReqlQueryLogicError", "`-00` is not a valid time offset."), r.time(2013, 1, 1, "-00"));
		@:await assertError(err("ReqlQueryLogicError", "`-00:00` is not a valid time offset."), r.time(2013, 1, 1, "-00:00"));
		@:await assertError(err("ReqlQueryLogicError", "Timezone `UTC+00` does not start with `-` or `+`."), r.time(2013, 1, 1, "UTC+00"));
		@:await assertError(err("ReqlQueryLogicError", "Minutes out of range in `+00:60`."), r.time(2013, 1, 1, "+00:60"));
		@:await assertError(err("ReqlQueryLogicError", "Hours out of range in `+25:00`."), r.time(2013, 1, 1, "+25:00"));
		@:await assertAtom(("2015-07-08T00:00:00-08:00"), r.epochTime(1436428422.339).inTimezone("-08:00").date().toIso8601());
		@:await assertAtom(("2015-07-09T00:00:00-07:00"), r.epochTime(1436428422.339).inTimezone("-07:00").date().toIso8601());
		return Noise;
	}
}