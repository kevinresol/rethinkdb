package ;

import deepequal.DeepEqual.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.response.*;

using RethinkDBApi;
using tink.CoreApi;

@:await
class RunTests {
	
	@:await static function main() {
		
		var conn = r.connect();
		var tests = [
			// >>>>
			// new TestArity(conn),
			// new TestControl(conn),
			// new TestDefault(conn),
			// new TestMatch(conn),
			// new TestPolymorphism(conn),
			// new TestSelection(conn),
			// new TestTimeout(conn),
			// new changefeeds.TestIdxcopy(conn),
			// new changefeeds.TestInclude_states(conn),
			// new changefeeds.TestPoint(conn),
			// new changefeeds.TestSindex(conn),
			// new changefeeds.TestSquash(conn),
			// new changefeeds.TestTable(conn),
			// new datum.TestArray(conn),
			// new datum.TestBool(conn),
			// new datum.TestNull(conn),
			// new datum.TestNumber(conn),
			// new datum.TestObject(conn),
			// new datum.TestTypeof(conn),
			// new datum.TestUuid(conn),
			// new geo.TestConstructors(conn),
			// new geo.TestGeojson(conn),
			// new geo.TestIndexing(conn),
			// new geo.TestIntersection_inclusion(conn),
			// new geo.TestOperations(conn),
			// new geo.TestPrimitives(conn),
			// new math_logic.TestAdd(conn),
			// new math_logic.TestAliases(conn),
			// new math_logic.TestDiv(conn),
			// new math_logic.TestFloor_ceil_round(conn),
			// new math_logic.TestLogic(conn),
			// new math_logic.TestMath(conn),
			// new math_logic.TestMod(conn),
			// new math_logic.TestMul(conn),
			// new math_logic.TestSub(conn),
			new meta.TestDbs(conn),
			// new meta.TestGrant(conn),
			// new meta.TestTable(conn),
			// new mutation.TestAtomic_get_set(conn),
			// new mutation.TestDelete(conn),
			// new mutation.TestInsert(conn),
			// new mutation.TestReplace(conn),
			// new mutation.TestSync(conn),
			// new mutation.TestUpdate(conn),
			// new mutation.TestWrite_hook(conn),
			// new regression.Test1001(conn),
			// new regression.Test1005(conn),
			// new regression.Test1081(conn),
			// new regression.Test1132(conn),
			// new regression.Test1155(conn),
			// new regression.Test1179(conn),
			// new regression.Test1468(conn),
			// new regression.Test1789(conn),
			// new regression.Test2052(conn),
			// new regression.Test2696(conn),
			// new regression.Test2697(conn),
			// new regression.Test2709(conn),
			// new regression.Test2710(conn),
			// new regression.Test2766(conn),
			// new regression.Test2767(conn),
			// new regression.Test2930(conn),
			// new regression.Test3057(conn),
			// new regression.Test3059(conn),
			// new regression.Test309(conn),
			// new regression.Test3444(conn),
			// new regression.Test354(conn),
			// new regression.Test3637(conn),
			// new regression.Test370(conn),
			// new regression.Test3745(conn),
			// new regression.Test3759(conn),
			// new regression.Test4030(conn),
			// new regression.Test4132(conn),
			// new regression.Test4146(conn),
			// new regression.Test4431(conn),
			// new regression.Test4462(conn),
			// new regression.Test4501(conn),
			// new regression.Test453(conn),
			// new regression.Test4582(conn),
			// new regression.Test4591(conn),
			// new regression.Test46(conn),
			// new regression.Test469(conn),
			// new regression.Test4729(conn),
			// new regression.Test5241(conn),
			// new regression.Test5438(conn),
			// new regression.Test545(conn),
			// new regression.Test546(conn),
			// new regression.Test568(conn),
			// new regression.Test578(conn),
			// new regression.Test579(conn),
			// new regression.Test619(conn),
			// new regression.Test665(conn),
			// new regression.Test678(conn),
			// new regression.Test718(conn),
			// new regression.Test730(conn),
			// new regression.Test757(conn),
			// new regression.Test767(conn),
			// new regression.Test831(conn),
			// new sindex.TestApi(conn),
			// new sindex.TestNullsinstrings(conn),
			// new sindex.TestStatus(conn),
			// new times.TestApi(conn),
			// new times.TestConstructors(conn),
			// new times.TestPortions(conn),
			// new times.TestTimezones(conn),
			// new transform.TestArray(conn),
			// new transform.TestFold(conn),
			// new transform.TestMap(conn),
			// new transform.TestObject(conn),
			// new transform.TestTable(conn),
			// new transform.TestUnordered_map(conn),
			// <<<<
		];
		
		var errors:Array<Error> = [];
		var total = 0;
		for(test in tests) {
			var o = @:await test.run();
			total += o.a;
			errors = errors.concat(o.b);
		}
		trace('$total Tests : ${errors.length} Errors');
		if(errors.length > 0) for(e in errors) trace(e);
		Sys.exit(errors.length);
	}
}