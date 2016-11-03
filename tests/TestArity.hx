package ;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestArity extends TestBase {
	override function test() {
		var db = r.db("test");
		var obj = r.expr({ a : 1 });
		var array = r.expr([1]);
		assertError("ReqlCompileError", "Expected 0 arguments but found 1.", r.dbList(1));
		assertError("ReqlQueryLogicError", "Empty ERROR term outside a default block.", r.error());
		assertError("ReqlCompileError", "Expected between 0 and 1 arguments but found 2.", r.error(1, 2));
		assertError("ReqlQueryLogicError", "Expected type DATUM but found DATABASE:", db.tableDrop());
		assertError("ReqlCompileError", "Expected between 1 and 2 arguments but found 3.", db.tableDrop(1, 2));
		assertError("ReqlCompileError", "Expected between 2 and 3 arguments but found 1.", r.expr([]).deleteAt());
		assertError("ReqlCompileError", "Expected between 1 and 2 arguments but found 3.", tbl.count(1, 2));
		assertError("ReqlCompileError", "Expected 2 arguments but found 1.", tbl.reduce());
		assertError("ReqlCompileError", "Expected 3 or more arguments but found 2.", r.branch(1, 2));
		assertError("ReqlQueryLogicError", "Cannot call `branch` term with an even number of arguments.", r.branch(1, 2, 3, 4));
		assertAtom(10, tbl.insert([{ id : 0 }, { id : 1 }, { id : 2 }, { id : 3 }, { id : 4 }, { id : 5 }, { id : 6 }, { id : 7 }, { id : 8 }, { id : 9 }]).getField("inserted"));
		assertAtom(bag([0, 1, 2]), tbl.getAll(0, 1, 2).getField("id"));
		assertAtom(bag([0, 1, 2]), tbl.getAll(r.args([]), 0, 1, 2).getField("id"));
		assertAtom(bag([0, 1, 2]), tbl.getAll(r.args([0]), 1, 2).getField("id"));
		assertAtom(bag([0, 1, 2]), tbl.getAll(r.args([0, 1]), 2).getField("id"));
		assertAtom(bag([0, 1, 2]), tbl.getAll(r.args([0, 1, 2])).getField("id"));
		assertAtom(bag([0, 1, 2]), tbl.getAll(r.args([0]), 1, r.args([2])).getField("id"));
		assertAtom(1, r.branch(true, 1, r.error("a")));
		assertAtom(1, r.branch(r.args([true, 1]), r.error("a")));
		assertAtom(1, r.expr(true).branch(1, 2));
		assertError("ReqlUserError", "a", r.branch(r.args([true, 1, r.error("a")])));
		assertAtom(([{ group : 0, reduction : 1 }]), tbl.group(function(row) return row["id"].mod(2)).count({ id : 0 }).ungroup());
		assertAtom(([{ group : 0, reduction : 1 }]), tbl.group(r.row["id"].mod(2)).count(r.args([{ id : 0 }])).ungroup());
		assertAtom(({ a : { c : 1 } }), r.expr({ a : { b : 1 } }).merge(r.args([{ a : r.literal({ c : 1 }) }])));
		assertError("ReqlServerCompileError", "Expected 0 arguments but found 1.", r.now("foo"));
		assertError("ReqlQueryLogicError", "Expected 0 arguments but found 3.", r.now(r.args([1, 2, 3])));
	}
}