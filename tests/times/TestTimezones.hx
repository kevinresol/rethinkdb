package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestTimezones extends TestBase {
	override function test() {
		var t1 = r.time(2013, r.july, 29, 23, 30, 0, "+00:00");
		var tutc1 = t1.inTimezone("Z");
		var tutc2 = t1.inTimezone("+00:00");
		var tutc3 = t1.inTimezone("+00");
		var tutcs = r.expr([tutc1, tutc2, tutc3]);
		var tm1 = t1.inTimezone("-00:59");
		var tm2 = t1.inTimezone("-01:00");
		var tm3 = t1.inTimezone("-01:01");
		var tms = r.expr([tm1, tm2, tm3]);
		var tp1 = t1.inTimezone("+00:59");
		var tp2 = t1.inTimezone("+01:00");
		var tp3 = t1.inTimezone("+01:01");
		var tps = r.expr([tp1, tp2, tp3]);
		var ts = tutcs.union(tms).union(tps).union([t1]);
		assertAtom(([["+00:00", 29], ["+00:00", 29], ["+00:00", 29]]), tutcs.map(function(x) return [x.timezone(), x.day()]));
		assertAtom(([["-00:59", 29], ["-01:00", 29], ["-01:01", 29]]), tms.map(function(x) return [x.timezone(), x.day()]));
		assertAtom(([["+00:59", 30], ["+01:00", 30], ["+01:01", 30]]), tps.map(function(x) return [x.timezone(), x.day()]));
		assertAtom(([0]), ts.concatMap(function(x) return ts.map(function(y) return x - y)).distinct());
		assertError("ReqlQueryLogicError", "Timezone `` does not start with `-` or `+`.", r.now().inTimezone(""));
		assertError("ReqlQueryLogicError", "`-00` is not a valid time offset.", r.now().inTimezone("-00"));
		assertError("ReqlQueryLogicError", "`-00:00` is not a valid time offset.", r.now().inTimezone("-00:00"));
		assertError("ReqlQueryLogicError", "Timezone `UTC+00` does not start with `-` or `+`.", r.now().inTimezone("UTC+00"));
		assertError("ReqlQueryLogicError", "Minutes out of range in `+00:60`.", r.now().inTimezone("+00:60"));
		assertError("ReqlQueryLogicError", "Hours out of range in `+25:00`.", r.now().inTimezone("+25:00"));
		assertError("ReqlQueryLogicError", "Timezone `` does not start with `-` or `+`.", r.time(2013, 1, 1, ""));
		assertError("ReqlQueryLogicError", "`-00` is not a valid time offset.", r.time(2013, 1, 1, "-00"));
		assertError("ReqlQueryLogicError", "`-00:00` is not a valid time offset.", r.time(2013, 1, 1, "-00:00"));
		assertError("ReqlQueryLogicError", "Timezone `UTC+00` does not start with `-` or `+`.", r.time(2013, 1, 1, "UTC+00"));
		assertError("ReqlQueryLogicError", "Minutes out of range in `+00:60`.", r.time(2013, 1, 1, "+00:60"));
		assertError("ReqlQueryLogicError", "Hours out of range in `+25:00`.", r.time(2013, 1, 1, "+25:00"));
		assertAtom(("2015-07-08T00:00:00-08:00"), r.epochTime(1436428422.339).inTimezone("-08:00").date().toIso8601());
		assertAtom(("2015-07-09T00:00:00-07:00"), r.epochTime(1436428422.339).inTimezone("-07:00").date().toIso8601());
	}
}