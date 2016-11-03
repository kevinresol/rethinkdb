package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestPortions extends TestBase {
	override function test() {
		var rt1 = 1375147296.681;
		var rt2 = 1375147296.682;
		var rt3 = 1375147297.681;
		var rt4 = 2375147296.681;
		var rts = [rt1, rt2, rt3, rt4];
		var t1 = r.epochTime(rt1);
		var t2 = r.epochTime(rt2);
		var t3 = r.epochTime(rt3);
		var t4 = r.epochTime(rt4);
		var ts = r.expr([t1, t2, t3, t4]);
		assertAtom(([1375142400, 1375142400, 1375142400, 2375136000]), ts.map(function(x) return x.date()).map(function(x) return x.toEpochTime()));
		assertAtom(([0, 0, 0, 0]), ts.map(function(x) return x.date().timeOfDay()));
		assertAtom(([4896.681, 4896.682, 4897.681, 11296.681]), ts.map(function(x) return x.timeOfDay()));
		assertAtom(([[2013, 7, 30, 1, 21, 36.681], [2013, 7, 30, 1, 21, 36.682], [2013, 7, 30, 1, 21, 37.681], [2045, 4, 7, 3, 8, 16.681]]), ts.map(function(x) return [x.year(), x.month(), x.day(), x.hours(), x.minutes(), x.seconds()]));
		assertAtom(rts, ts.map(function(x) return r.time(x.year(), x.month(), x.day(), x.hours(), x.minutes(), x.seconds(), x.timezone())).map(function(x) return x.toEpochTime()));
		assertAtom(0, ts.map(function(x) return r.time(x.year(), x.month(), x.day(), x.hours(), x.minutes(), x.seconds(), x.timezone())).union(ts).map(function(x) return x.toIso8601()).distinct().count().sub(ts.count()));
		assertAtom([[2, 211], [2, 211], [2, 211], [5, 97]], ts.map([r.row.dayOfWeek(), r.row.dayOfYear()]));
	}
}