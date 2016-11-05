package times;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestConstructors extends TestBase {
	@:async
	override function test() {
		@:await assertAtom(1, r.epochTime(1).toEpochTime());
		@:await assertAtom(-1, r.epochTime(-1).toEpochTime());
		@:await assertAtom(1.444, r.epochTime(1.4444445).toEpochTime());
		@:await assertAtom("1970-01-01T00:00:01.444+00:00", r.epochTime(1.4444445).toIso8601());
		@:await assertAtom(1.444, r.epochTime(1.4444445).seconds());
		@:await assertAtom(10000, r.epochTime(253430000000).year());
		@:await assertError("ReqlQueryLogicError", "Year `10000` out of valid ISO 8601 range [0, 9999].", r.epochTime(253430000000).toIso8601());
		@:await assertError("ReqlQueryLogicError", "Error in time logic: Year is out of valid range: 1400..10000.", r.epochTime(253440000000).year());
		@:await assertAtom(253440000000, r.epochTime(253440000000).toEpochTime());
		@:await assertAtom(1400, r.epochTime(-17980000000).year());
		@:await assertError("ReqlQueryLogicError", "Error in time logic: Year is out of valid range: 1400..10000.", r.epochTime(-17990000000).year());
		@:await assertAtom(-17990000000, r.epochTime(-17990000000).toEpochTime());
		var cdate = "2013-01-01";
		var dates = ["2013", "2013-01", "2013-01-01", "20130101", "2013-001", "2013001"];
		var ctime = "13:00:00";
		var times = ["13", "13:00", "1300", "13:00:00", "13:00:00.000000", "130000.000000"];
		var ctz = "+00:00";
		var tzs = ["Z", "+00", "+0000", "+00:00"];
		var cdt = [cdate + "T" + ctime + ctz];
		var bad_dates = ["201301", "2013-0101", "2a13", "2013+01", "2013-01-01.1"];
		var bad_times = ["a3", "13:0000", "13:000", "13:00.00", "130000.00000000a"];
		var bad_tzs = ["X", "-7", "-07:-1", "+07+01", "PST", "UTC", "Z+00"];
		return Noise;
	}
}