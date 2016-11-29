package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestArity extends TestBase {
	@:async
	override function test() {
		var _tables = ["tbl"];
		@:await createTables(_tables);
		var tbl = r.db("test").table("tbl");
		var db = r.db("test");
		var obj = r.expr({ "a" : 1 });
		var array = r.expr(([1] : Array<Dynamic>));
		@:await assertError(err("ReqlQueryLogicError", "Empty ERROR term outside a default block.", ([] : Array<Dynamic>)), r.error());
		@:await assertError(err_regex("TypeError", ".* takes at least 1 (?:positional )?argument \(0 given\)", ([] : Array<Dynamic>)), r.expr());
		@:await assertError(err("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", ([] : Array<Dynamic>)), db.tableDrop());
		@:await assertError(err("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", ([] : Array<Dynamic>)), db.tableCreate());
		@:await assertError(err("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", ([] : Array<Dynamic>)), db.table());
		@:await assertError(err("ReqlQueryLogicError", "Cannot call `branch` term with an even number of arguments.", ([] : Array<Dynamic>)), r.branch(1, 2, 3, 4));
		@:await assertAtom(10, tbl.insert(([{ "id" : 0 }, { "id" : 1 }, { "id" : 2 }, { "id" : 3 }, { "id" : 4 }, { "id" : 5 }, { "id" : 6 }, { "id" : 7 }, { "id" : 8 }, { "id" : 9 }] : Array<Dynamic>)).getField("inserted"));
		@:await assertAtom(bag(([0, 1, 2] : Array<Dynamic>)), tbl.getAll(0, 1, 2).getField("id"));
		@:await assertAtom(bag(([0, 1, 2] : Array<Dynamic>)), tbl.getAll(r.args(([] : Array<Dynamic>)), 0, 1, 2).getField("id"));
		@:await assertAtom(bag(([0, 1, 2] : Array<Dynamic>)), tbl.getAll(r.args(([0] : Array<Dynamic>)), 1, 2).getField("id"));
		@:await assertAtom(bag(([0, 1, 2] : Array<Dynamic>)), tbl.getAll(r.args(([0, 1] : Array<Dynamic>)), 2).getField("id"));
		@:await assertAtom(bag(([0, 1, 2] : Array<Dynamic>)), tbl.getAll(r.args(([0, 1, 2] : Array<Dynamic>))).getField("id"));
		@:await assertAtom(bag(([0, 1, 2] : Array<Dynamic>)), tbl.getAll(r.args(([0] : Array<Dynamic>)), 1, r.args(([2] : Array<Dynamic>))).getField("id"));
		@:await assertAtom(1, r.branch(true, 1, r.error("a")));
		@:await assertAtom(1, r.branch(r.args(([true, 1] : Array<Dynamic>)), r.error("a")));
		@:await assertAtom(1, r.expr(true).branch(1, 2));
		@:await assertError(err("ReqlUserError", "a", ([] : Array<Dynamic>)), r.branch(r.args(([true, 1, r.error("a")] : Array<Dynamic>))));
		@:await assertAtom((([{ "group" : 0, "reduction" : 1 }] : Array<Dynamic>)), tbl.group(function(row:Expr):Expr return row["id"].mod(2)).count({ "id" : 0 }).ungroup());
		@:await assertAtom((([{ "group" : 0, "reduction" : 1 }] : Array<Dynamic>)), tbl.group(r.row["id"].mod(2)).count(r.args(([{ "id" : 0 }] : Array<Dynamic>))).ungroup());
		@:await assertAtom(({ "a" : { "c" : 1 } }), r.expr({ "a" : { "b" : 1 } }).merge(r.args(([{ "a" : r.literal({ "c" : 1 }) }] : Array<Dynamic>))));
		@:await assertError(err_regex("TypeError", ".*takes exactly 1 argument \(2 given\)", ([] : Array<Dynamic>)), r.http("httpbin.org/get", "bad_param"));
		@:await assertError(err_regex("TypeError", ".*takes exactly 1 argument \(2 given\)", ([] : Array<Dynamic>)), r.binary("1", "2"));
		@:await assertError(err_regex("TypeError", ".*takes exactly 1 argument \(0 given\)", ([] : Array<Dynamic>)), r.binary());
		@:await assertError(err("ReqlServerCompileError", "Expected 0 arguments but found 1."), r.now("foo"));
		@:await assertError(err("ReqlQueryLogicError", "Expected 0 arguments but found 3."), r.now(r.args(([1, 2, 3] : Array<Dynamic>))));
		@:await dropTables(_tables);
		return Noise;
	}
}