package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestArray extends TestBase {
	@:async
	override function test() {
		var arr = r.expr([1, 2, 3]);
		var dupe_arr = r.expr([1, 1, 2, 3]);
		var objArr = r.expr([{ "a" : 1, "b" : "a" }, { "a" : 2, "b" : "b" }, { "a" : 3, "b" : "c" }]);
		var nestedObjArr = r.expr([{ "a" : 1, "b" : { "c" : 1 } }, { "a" : 2, "b" : { "c" : 2 } }, { "a" : 3, "b" : { "c" : 3 } }]);
		@:await assertAtom([1, 2, 3, 4], arr.append(4));
		@:await assertAtom([1, 2, 3, "a"], arr.append("a"));
		@:await assertAtom([0, 1, 2, 3], arr.prepend(0));
		@:await assertAtom(["a", 1, 2, 3], arr.prepend("a"));
		@:await assertAtom([3], arr.difference([1, 2, 2]));
		@:await assertAtom([1, 2, 3], arr.difference([]));
		@:await assertAtom([1, 2, 3], arr.difference(["foo", "bar"]));
		@:await assertAtom([1, 2, 3], dupe_arr.setInsert(1));
		@:await assertAtom([1, 2, 3, 4], dupe_arr.setInsert(4));
		@:await assertAtom([1, 2, 3, 4, 5], dupe_arr.setUnion([3, 4, 5, 5]));
		@:await assertAtom([1, 2, 3, 5, 6], dupe_arr.setUnion([5, 6]));
		@:await assertAtom([1, 2], dupe_arr.setIntersection([1, 1, 1, 2, 2]));
		@:await assertAtom([], dupe_arr.setIntersection(["foo"]));
		@:await assertAtom([2, 3], dupe_arr.setDifference([1, 1, 1, 10]));
		@:await assertAtom([1, 3], dupe_arr.setDifference([2]));
		@:await assertAtom([2], arr.slice(-2, -1));
		@:await assertAtom([2, 3], arr.skip(1));
		@:await assertAtom([3], arr.skip(2));
		@:await assertAtom([], arr.skip(12));
		@:await assertAtom([1, 2], arr.limit(2));
		@:await assertAtom([], arr.limit(0));
		@:await assertAtom([1, 2, 3], arr.limit(12));
		@:await assertAtom([{ "a" : 1, "b" : "a" }, { "a" : 2, "b" : "b" }, { "a" : 3, "b" : "c" }], objArr.pluck("a", "b"));
		@:await assertAtom([{ "a" : 1 }, { "a" : 2 }, { "a" : 3 }], objArr.pluck("a"));
		@:await assertAtom([{  }, {  }, {  }], objArr.pluck());
		var wftst = objArr.union(objArr.pluck("a")).union(objArr.pluck("b")).union([{ "a" : null }]);
		@:await assertAtom(([{ "a" : 1 }, { "a" : 2 }, { "a" : 3 }, { "a" : 1 }, { "a" : 2 }, { "a" : 3 }]), wftst.withFields("a"));
		@:await assertAtom(([{ "b" : "a" }, { "b" : "b" }, { "b" : "c" }, { "b" : "a" }, { "b" : "b" }, { "b" : "c" }]), wftst.withFields("b"));
		@:await assertAtom(([{ "a" : 1, "b" : "a" }, { "a" : 2, "b" : "b" }, { "a" : 3, "b" : "c" }]), wftst.withFields("a", "b"));
		@:await assertAtom([{  }, {  }, {  }, {  }, {  }, {  }, {  }, {  }, {  }, {  }], wftst.withFields());
		var wftst2 = nestedObjArr.union(objArr.pluck({ "b" : "missing" })).union(nestedObjArr.pluck({ "b" : "c" }));
		@:await assertAtom(([{ "b" : { "c" : 1 } }, { "b" : { "c" : 2 } }, { "b" : { "c" : 3 } }, { "b" : { "c" : 1 } }, { "b" : { "c" : 2 } }, { "b" : { "c" : 3 } }]), wftst2.withFields({ "b" : "c" }));
		@:await assertError("ReqlQueryLogicError", "Invalid path argument `1`.", wftst.withFields(1));
		@:await assertError("ReqlQueryLogicError", "Cannot perform has_fields on a non-object non-sequence `1`.", r.expr(1).withFields());
		@:await assertAtom([{  }, {  }, {  }], objArr.without("a", "b"));
		@:await assertAtom([{ "b" : "a" }, { "b" : "b" }, { "b" : "c" }], objArr.without("a"));
		@:await assertAtom([{ "a" : 1, "b" : "a" }, { "a" : 2, "b" : "b" }, { "a" : 3, "b" : "c" }], objArr.without());
		@:await assertAtom([2, 3, 4], arr.map(function(v) return v + 1));
		@:await assertAtom(6, arr.reduce(function(a, b) return a + b));
		@:await assertAtom(6, arr.reduce(function(a, b) return a + b));
		@:await assertAtom(12, arr.union(arr).reduce(function(a, b) return a + b));
		@:await assertAtom(12, arr.union(arr).reduce(function(a, b) return a + b));
		@:await assertAtom([1, 2, 1, 2, 1, 2], arr.concatMap(function(v) return [1, 2]));
		@:await assertAtom([{ "v" : 1 }, { "v2" : 2 }, { "v" : 2 }, { "v2" : 3 }, { "v" : 3 }, { "v2" : 4 }], arr.concatMap(function(v) return [{ "v" : v }, { "v2" : v + 1 }]));
		@:await assertAtom([{ "a" : 1, "b" : "a" }, { "a" : 2, "b" : "b" }, { "a" : 3, "b" : "c" }], objArr.orderBy("b"));
		@:await assertAtom([{ "a" : 3, "b" : "c" }, { "a" : 2, "b" : "b" }, { "a" : 1, "b" : "a" }], objArr.orderBy(r.desc("b")));
		@:await assertAtom([{ "-a" : 1 }, { "-a" : 2 }], r.expr([{ "-a" : 1 }, { "-a" : 2 }]).orderBy("-a"));
		@:await assertAtom([1, 2, 3, 4], r.expr([1, 1, 2, 2, 2, 3, 4]).distinct());
		@:await assertAtom(3, objArr.count());
		@:await assertAtom([1, 2, 3, { "a" : 1, "b" : "a" }, { "a" : 2, "b" : "b" }, { "a" : 3, "b" : "c" }], arr.union(objArr));
		@:await assertAtom(2, arr[1]);
		@:await assertAtom(2, arr.nth(1));
		@:await assertAtom(1, arr[0]);
		@:await assertAtom(true, r.expr([]).isEmpty());
		@:await assertAtom(false, arr.isEmpty());
		@:await assertAtom(true, arr.contains(2));
		@:await assertAtom(true, arr.contains(2, 3));
		@:await assertAtom(false, arr.contains(4));
		@:await assertAtom(false, arr.contains(2, 4));
		@:await assertAtom(false, arr.contains(2, 2));
		@:await assertAtom(true, arr.union(arr).contains(2, 2));
		@:await assertAtom([1, 3], r.expr([{ "a" : 1 }, { "b" : 2 }, { "a" : 3, "c" : 4 }])["a"]);
		@:await assertError("ReqlQueryLogicError", "Cannot perform bracket on a non-object non-sequence `\"a\"`.", r.expr([{ "a" : 1 }, "a", { "b" : 2 }, { "a" : 3, "c" : 4 }])["a"]);
		return Noise;
	}
}