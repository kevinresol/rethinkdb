package regression;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class Test2697 extends TestBase {
	override function test() {
		var ten_l = r.expr([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
		assertAtom(({ inserted : 1 }), tbl.insert({ id : 1, a : r.expr(ten_l).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))) }).pluck("first_error", "inserted"));
		assertAtom(({ first_error : "Array over size limit `100000`.  To raise the number of allowed elements, modify the `array_limit` option to `.run` (not available in the Data Explorer), or use an index." }), tbl.get(1).replace({ id : 1, a : r.row["a"].spliceAt(0, [2]) }).pluck("first_error"));
		assertAtom(100000, tbl.get(1)["a"].count());
		assertAtom(({ first_error : "Array over size limit `100000`.  To raise the number of allowed elements, modify the `array_limit` option to `.run` (not available in the Data Explorer), or use an index." }), tbl.get(1).replace({ id : 1, a : r.row["a"].insertAt(0, [2]) }).pluck("first_error"));
		assertAtom(100000, tbl.get(1)["a"].count());
		assertError("ReqlResourceLimitError", "Array over size limit `100000`.  To raise the number of allowed elements, modify the `array_limit` option to `.run` (not available in the Data Explorer), or use an index.", r.expr(ten_l).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).spliceAt(0, [1]).count());
		assertError("ReqlResourceLimitError", "Array over size limit `100000`.  To raise the number of allowed elements, modify the `array_limit` option to `.run` (not available in the Data Explorer), or use an index.", r.expr(ten_l).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).concatMap(function(l) return list(range(1))).insertAt(0, [1]).count());
	}
}