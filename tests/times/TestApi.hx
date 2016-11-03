package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestApi extends TestBase {
	override function test() {
		var rt1 = 1375147296.6812;
		var t1 = r.epochTime(rt1);
		var t2 = r.epochTime(rt1 + 1000);
		assertAtom((1375148296.681), (t1 + 1000).toEpochTime());
		assertAtom((1375146296.681), (t1 - 1000).toEpochTime());
		assertAtom(1000, (t1 - (t1 - 1000)));
		assertAtom(true, t1.during(t1, t1 + 1000));
		assertAtom(false, t1.during(t1, t1 + 1000, { left_bound : "open" }));
		assertAtom(false, t1.during(t1, t1));
		assertAtom(true, t1.during(t1, t1, { right_bound : "closed" }));
		assertAtom(1375142400, t1.date().toEpochTime());
		assertAtom((4896.681), t1.timeOfDay());
		assertAtom(2013, t1.year());
		assertAtom(7, t1.month());
		assertAtom(30, t1.day());
		assertAtom(2, t1.dayOfWeek());
		assertAtom(211, t1.dayOfYear());
		assertAtom(1, t1.hours());
		assertAtom(21, t1.minutes());
		assertAtom(36.681, t1.seconds());
		assertAtom((1375165800.1), r.time(2013, r.july, 29, 23, 30, 0.1, "-07:00").toEpochTime());
		assertAtom(("-07:00"), r.time(2013, r.july, 29, 23, 30, 0.1, "-07:00").timezone());
		assertError("ReqlQueryLogicError", "Got 6 arguments to TIME (expected 4 or 7).", r.time(2013, r.july, 29, 23, 30, 0.1).toEpochTime());
		assertError("ReqlQueryLogicError", "Got 6 arguments to TIME (expected 4 or 7).", r.time(2013, r.july, 29, 23, 30, 0.1).timezone());
		assertError("ReqlQueryLogicError", "Got 5 arguments to TIME (expected 4 or 7).", r.time(2013, r.july, 29, 23, 30).toEpochTime());
		assertError("ReqlQueryLogicError", "Expected type STRING but found NUMBER.", r.time(2013, r.july, 29, 23).toEpochTime());
		assertAtom(1375081200, r.time(2013, r.july, 29, "-07:00").toEpochTime());
		assertAtom(("-07:00"), r.time(2013, r.july, 29, "-07:00").timezone());
		assertError("ReqlCompileError", "Expected between 4 and 7 arguments but found 3.", r.time(2013, r.july, 29).toEpochTime());
		assertError("ReqlCompileError", "Expected between 4 and 7 arguments but found 3.", r.time(2013, r.july, 29).timezone());
		assertAtom(1375242965, r.iso8601("2013-07-30T20:56:05-07:00").toEpochTime());
		assertAtom(("2013-07-30T20:56:05-07:00"), r.epochTime(1375242965).inTimezone("-07:00").toIso8601());
		assertAtom(("PTYPE<TIME>"), r.now().typeOf());
		assertAtom(0, (r.now() - r.now()));
		assertError("ReqlQueryLogicError", "ISO 8601 string has no time zone, and no default time zone was provided.", r.iso8601("2013-07-30T20:56:05").toIso8601());
		assertAtom(("2013-07-30T20:56:05-07:00"), r.iso8601("2013-07-30T20:56:05", { default_timezone : "-07" }).toIso8601());
		assertAtom(([1, 2, 3, 4, 5, 6, 7]), r.expr([r.monday, r.tuesday, r.wednesday, r.thursday, r.friday, r.saturday, r.sunday]));
		assertAtom(([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]), r.expr([r.january, r.february, r.march, r.april, r.may, r.june, r.july, r.august, r.september, r.october, r.november, r.december]));
	}
}