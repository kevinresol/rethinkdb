package transform;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi

@:await class TestObject extends TestBase {
	@:async
	override function test() {
		{
			var obj = r.expr({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : { "f" : "buzz" } });
			@:await assertAtom(1, obj["a"]);
			@:await assertAtom("str", obj["c"]);
			@:await assertAtom(true, obj.hasFields("b"));
			@:await assertAtom(true, obj.keys().contains("d"));
			@:await assertAtom(false, obj.hasFields("d"));
			@:await assertAtom(true, obj.hasFields({ "e" : "f" }));
			@:await assertAtom(false, obj.hasFields({ "e" : "g" }));
			@:await assertAtom(false, obj.hasFields("f"));
			@:await assertAtom(true, obj.hasFields("a", "b"));
			@:await assertAtom(false, obj.hasFields("a", "d"));
			@:await assertAtom(false, obj.hasFields("a", "f"));
			@:await assertAtom(true, obj.hasFields("a", { "e" : "f" }));
			@:await assertAtom(2, r.expr([obj, obj.pluck("a", "b")]).hasFields("a", "b").count());
			@:await assertAtom(1, r.expr([obj, obj.pluck("a", "b")]).hasFields("a", "c").count());
			@:await assertAtom(2, r.expr([obj, obj.pluck("a", "e")]).hasFields("a", { "e" : "f" }).count());
			@:await assertAtom({ "a" : 1 }, obj.pluck("a"));
			@:await assertAtom({ "a" : 1, "b" : 2 }, obj.pluck("a", "b"));
			@:await assertAtom({ "b" : 2, "c" : "str", "d" : null, "e" : { "f" : "buzz" } }, obj.without("a"));
			@:await assertAtom({ "c" : "str", "d" : null, "e" : { "f" : "buzz" } }, obj.without("a", "b"));
			@:await assertAtom({ "e" : { "f" : "buzz" } }, obj.without("a", "b", "c", "d"));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : {  } }, obj.without({ "e" : "f" }));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : { "f" : "buzz" } }, obj.without({ "e" : "buzz" }));
			@:await assertAtom(1, obj.merge(1));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : -2 }, obj.merge({ "e" : -2 }));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null }, obj.merge({ "e" : r.literal() }));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : { "f" : "quux" } }, obj.merge({ "e" : { "f" : "quux" } }));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : { "f" : "buzz", "g" : "quux" } }, obj.merge({ "e" : { "g" : "quux" } }));
			@:await assertAtom({ "a" : 1, "b" : 2, "c" : "str", "d" : null, "e" : { "g" : "quux" } }, obj.merge({ "e" : r.literal({ "g" : "quux" }) }));
			@:await assertAtom({ "a" : -1, "b" : 2, "c" : "str", "d" : null, "e" : { "f" : "buzz" } }, obj.merge({ "a" : -1 }));
			var errmsg = "Stray literal keyword found:" + " literal is only legal inside of the object passed to merge or update and cannot nest inside other literals.";
			@:await assertError("ReqlQueryLogicError", errmsg, r.literal("foo"));
			@:await assertError("ReqlQueryLogicError", errmsg, obj.merge(r.literal("foo")));
			@:await assertError("ReqlQueryLogicError", errmsg, obj.merge({ "foo" : r.literal(r.literal("foo")) }));
			var o = r.expr({ "a" : { "b" : 1, "c" : 2 }, "d" : 3 });
			@:await assertAtom({ "a" : { "b" : 1, "c" : 2 }, "d" : 3, "e" : 4, "f" : 5 }, o.merge({ "e" : 4 }, { "f" : 5 }));
			@:await assertAtom([{ "a" : { "b" : 1, "c" : 2 }, "d" : 3, "e" : 3 }, { "a" : { "b" : 1, "c" : 2 }, "d" : 4, "e" : 4 }], r.expr([o, o.merge({ "d" : 4 })]).merge(function(row) return { "e" : row["d"] }));
			@:await assertAtom([{ "a" : { "b" : 1, "c" : 2 }, "d" : 3, "e" : 3 }, { "a" : { "b" : 1, "c" : 2 }, "d" : 4, "e" : 4 }], r.expr([o, o.merge({ "d" : 4 })]).merge({ "e" : r.row["d"] }));
			@:await assertAtom([{ "a" : { "b" : 2, "c" : 2 }, "d" : 3 }, { "a" : { "b" : 2, "c" : 2 }, "d" : 4 }], r.expr([o, o.merge({ "d" : 4 })]).merge(function(row) return { "a" : { "b" : 2 } }));
			@:await assertAtom([{ "a" : { "b" : 2 }, "d" : 3 }, { "a" : { "b" : 2 }, "d" : 4 }], r.expr([o, o.merge({ "d" : 4 })]).merge(function(row) return { "a" : r.literal({ "b" : 2 }) }));
			@:await assertAtom(["a", "b", "c", "d", "e"], obj.keys());
			@:await assertAtom([1, 2, "str", null, { "f" : "buzz" }], obj.values());
			@:await assertAtom(5, obj.count());
		};
		return Noise;
	}
}