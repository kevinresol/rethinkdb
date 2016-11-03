package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestObject extends TestBase {
	override function test() {
		var obj = r.expr({ a : 1, b : 2, c : "str", d : null, e : { f : "buzz" } });
		assertAtom(1, obj["a"]);
		assertAtom(str, obj["c"]);
		assertAtom(true, obj.hasFields("b"));
		assertAtom(true, obj.keys().contains("d"));
		assertAtom(false, obj.hasFields("d"));
		assertAtom(true, obj.hasFields({ e : "f" }));
		assertAtom(false, obj.hasFields({ e : "g" }));
		assertAtom(false, obj.hasFields("f"));
		assertAtom(true, obj.hasFields("a", "b"));
		assertAtom(false, obj.hasFields("a", "d"));
		assertAtom(false, obj.hasFields("a", "f"));
		assertAtom(true, obj.hasFields("a", { e : "f" }));
		assertAtom(2, r.expr([obj, obj.pluck("a", "b")]).hasFields("a", "b").count());
		assertAtom(1, r.expr([obj, obj.pluck("a", "b")]).hasFields("a", "c").count());
		assertAtom(2, r.expr([obj, obj.pluck("a", "e")]).hasFields("a", { e : "f" }).count());
		assertAtom(1, obj.merge(1));
		var errmsg = "Stray literal keyword found:" + " literal is only legal inside of the object passed to merge or update and cannot nest inside other literals.";
		assertError("ReqlQueryLogicError", errmsg, r.literal("foo"));
		assertError("ReqlQueryLogicError", errmsg, obj.merge(r.literal("foo")));
		assertError("ReqlQueryLogicError", errmsg, obj.merge({ foo : r.literal(r.literal("foo")) }));
		var o = r.expr({ a : { b : 1, c : 2 }, d : 3 });
		assertAtom(({ a : { b : 1, c : 2 }, d : 3, e : 4, f : 5 }), o.merge({ e : 4 }, { f : 5 }));
		assertAtom(([{ a : { b : 1, c : 2 }, d : 3, e : 3 }, { a : { b : 1, c : 2 }, d : 4, e : 4 }]), r.expr([o, o.merge({ d : 4 })]).merge(function(row) return { e : row["d"] }));
		assertAtom(([{ a : { b : 1, c : 2 }, d : 3, e : 3 }, { a : { b : 1, c : 2 }, d : 4, e : 4 }]), r.expr([o, o.merge({ d : 4 })]).merge({ e : r.row["d"] }));
		assertAtom(([{ a : { b : 2, c : 2 }, d : 3 }, { a : { b : 2, c : 2 }, d : 4 }]), r.expr([o, o.merge({ d : 4 })]).merge(function(row) return { a : { b : 2 } }));
		assertAtom(([{ a : { b : 2 }, d : 3 }, { a : { b : 2 }, d : 4 }]), r.expr([o, o.merge({ d : 4 })]).merge(function(row) return { a : r.literal({ b : 2 }) }));
		assertAtom((["a", "b", "c", "d", "e"]), obj.keys());
		assertAtom(([1, 2, "str", null, { f : "buzz" }]), obj.values());
		assertAtom(5, obj.count());
	}
}