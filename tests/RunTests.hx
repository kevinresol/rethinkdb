package ;

import deepequal.DeepEqual.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.response.*;

using RethinkDBApi;
using tink.CoreApi;

class RunTests {
	
	static function main() {
		
		var conn = r.connect();
		var tests = [
			// >>>>
			new TestArity(conn),
			new changefeeds.TestIdxcopy(conn),
			new changefeeds.TestSindex(conn),
			new changefeeds.TestSquash(conn),
			new datum.TestBool(conn),
			new datum.TestNull(conn),
			new datum.TestNumber(conn),
			new datum.TestObject(conn),
			new datum.TestTypeof(conn),
			new datum.TestUuid(conn),
			new TestDefault(conn),
			new geo.TestConstructors(conn),
			new geo.TestGeojson(conn),
			new geo.TestIntersection_inclusion(conn),
			new geo.TestOperations(conn),
			new geo.TestPrimitives(conn),
			new TestMatch(conn),
			new math_logic.TestAdd(conn),
			new math_logic.TestAliases(conn),
			new math_logic.TestDiv(conn),
			new math_logic.TestFloor_ceil_round(conn),
			new math_logic.TestLogic(conn),
			new math_logic.TestMath(conn),
			new math_logic.TestMod(conn),
			new math_logic.TestSub(conn),
			new meta.TestDbs(conn),
			new meta.TestTable(conn),
			new mutation.TestAtomic_get_set(conn),
			new mutation.TestDelete(conn),
			new mutation.TestReplace(conn),
			new mutation.TestSync(conn),
			new mutation.TestUpdate(conn),
			new TestPolymorphism(conn),
			new TestRange(conn),
			new regression.Test1001(conn),
			new regression.Test1005(conn),
			new regression.Test1081(conn),
			new regression.Test1132(conn),
			new regression.Test1155(conn),
			new regression.Test1179(conn),
			new regression.Test1468(conn),
			new regression.Test1789(conn),
			new regression.Test2052(conn),
			new regression.Test2696(conn),
			new regression.Test2697(conn),
			new regression.Test2709(conn),
			new regression.Test2710(conn),
			new regression.Test2766(conn),
			new regression.Test2767(conn),
			new regression.Test2930(conn),
			new regression.Test3057(conn),
			new regression.Test3059(conn),
			new regression.Test309(conn),
			new regression.Test3444(conn),
			new regression.Test354(conn),
			new regression.Test3637(conn),
			new regression.Test370(conn),
			new regression.Test3745(conn),
			new regression.Test3759(conn),
			new regression.Test4030(conn),
			new regression.Test4132(conn),
			new regression.Test4146(conn),
			new regression.Test4431(conn),
			new regression.Test4462(conn),
			new regression.Test4501(conn),
			new regression.Test4582(conn),
			new regression.Test4591(conn),
			new regression.Test46(conn),
			new regression.Test469(conn),
			new regression.Test545(conn),
			new regression.Test546(conn),
			new regression.Test568(conn),
			new regression.Test578(conn),
			new regression.Test579(conn),
			new regression.Test619(conn),
			new regression.Test665(conn),
			new regression.Test678(conn),
			new regression.Test718(conn),
			new regression.Test730(conn),
			new regression.Test757(conn),
			new regression.Test767(conn),
			new regression.Test831(conn),
			new sindex.TestNullsinstrings(conn),
			new sindex.TestStatus(conn),
			new TestTimeout(conn),
			new times.TestApi(conn),
			new times.TestPortions(conn),
			new times.TestTimezones(conn),
			new transform.TestMap(conn),
			new transform.TestObject(conn),
			new transform.TestTable(conn),
			// <<<<
		];
		
		Future.ofMany([for(test in tests) test.run()]).handle(function(outcomes) {
			var errors = [];
			var total = 0;
			for(o in outcomes) switch o {
				case Success(n): total += n;
				case Failure(e): errors = errors.concat(e);
			}
			trace('$total Tests : ${errors.length} Errors');
			if(errors.length > 0) for(e in errors) trace(e);
			Sys.exit(errors.length);
		});
	}
}