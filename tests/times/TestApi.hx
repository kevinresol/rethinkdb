package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestApi extends TestBase {
	@:async
	override function test() {
		var rt1 = 1375147296.6812;
		var t1 = r.epochTime(rt1);
		var t2 = r.epochTime(rt1 + 1000);
		@:await assertAtom((1375148296.681), (t1 + 1000).toEpochTime());
		@:await assertAtom((1375146296.681), (t1 - 1000).toEpochTime());
		@:await assertAtom(1000, (t1 - (t1 - 1000)));
		@:await assertAtom(false, (t1 < t1));
		@:await assertAtom(true, (t1 <= t1));
		@:await assertAtom(true, (t1 == t1));
		@:await assertAtom(false, (t1 != t1));
		@:await assertAtom(true, (t1 >= t1));
		@:await assertAtom(false, (t1 > t1));
		@:await assertAtom(true, (t1 < t2));
		@:await assertAtom(true, (t1 <= t2));
		@:await assertAtom(false, (t1 == t2));
		@:await assertAtom(true, (t1 != t2));
		@:await assertAtom(false, (t1 >= t2));
		@:await assertAtom(false, (t1 > t2));
		@:await assertAtom(true, t1.during(t1, t1 + 1000));
		@:await assertAtom(false, t1.during(t1, t1 + 1000, { "left_bound" : "open" }));
		@:await assertAtom(false, t1.during(t1, t1));
		@:await assertAtom(true, t1.during(t1, t1, { "right_bound" : "closed" }));
		@:await assertAtom(1375142400, t1.date().toEpochTime());
		@:await assertAtom((4896.681), t1.timeOfDay());
		@:await assertAtom(2013, t1.year());
		@:await assertAtom(7, t1.month());
		@:await assertAtom(30, t1.day());
		@:await assertAtom(2, t1.dayOfWeek());
		@:await assertAtom(211, t1.dayOfYear());
		@:await assertAtom(1, t1.hours());
		@:await assertAtom(21, t1.minutes());
		@:await assertAtom(36.681, t1.seconds());
		@:await assertAtom((1375165800.1), r.time(2013, r.july, 29, 23, 30, 0.1, "-07:00").toEpochTime());
		@:await assertAtom(("-07:00"), r.time(2013, r.july, 29, 23, 30, 0.1, "-07:00").timezone());
		@:await assertError(err("ReqlQueryLogicError", "Got 6 arguments to TIME (expected 4 or 7).", ([] : Array<Dynamic>)), r.time(2013, r.july, 29, 23, 30, 0.1).toEpochTime());
		@:await assertError(err("ReqlQueryLogicError", "Got 6 arguments to TIME (expected 4 or 7).", ([] : Array<Dynamic>)), r.time(2013, r.july, 29, 23, 30, 0.1).timezone());
		@:await assertError(err("ReqlQueryLogicError", "Got 5 arguments to TIME (expected 4 or 7).", ([] : Array<Dynamic>)), r.time(2013, r.july, 29, 23, 30).toEpochTime());
		@:await assertError(err("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", ([] : Array<Dynamic>)), r.time(2013, r.july, 29, 23).toEpochTime());
		@:await assertAtom(1375081200, r.time(2013, r.july, 29, "-07:00").toEpochTime());
		@:await assertAtom(("-07:00"), r.time(2013, r.july, 29, "-07:00").timezone());
		@:await assertAtom(1375242965, r.iso8601("2013-07-30T20:56:05-07:00").toEpochTime());
		@:await assertAtom(("2013-07-30T20:56:05-07:00"), r.epochTime(1375242965).inTimezone("-07:00").toIso8601());
		@:await assertAtom(("PTYPE<TIME>"), r.now().typeOf());
		@:await assertAtom(0, (r.now() - r.now()));
		@:await assertError(err("ReqlQueryLogicError", "ISO 8601 string has no time zone, and no default time zone was provided.", ([] : Array<Dynamic>)), r.iso8601("2013-07-30T20:56:05").toIso8601());
		@:await assertAtom(("2013-07-30T20:56:05-07:00"), r.iso8601("2013-07-30T20:56:05", { "default_timezone" : "-07" }).toIso8601());
		@:await assertAtom(([1, 2, 3, 4, 5, 6, 7] : Array<Dynamic>), r.expr(([r.monday, r.tuesday, r.wednesday, r.thursday, r.friday, r.saturday, r.sunday] : Array<Dynamic>)));
		@:await assertAtom(([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] : Array<Dynamic>), r.expr(([r.january, r.february, r.march, r.april, r.may, r.june, r.july, r.august, r.september, r.october, r.november, r.december] : Array<Dynamic>)));
		return Noise;
	}
}