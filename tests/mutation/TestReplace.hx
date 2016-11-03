package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestReplace extends TestBase {
	override function test() {
		assertAtom(100, tbl.count());
		assertAtom(({ deleted : 0.0, replaced : 0.0, unchanged : 1, errors : 0.0, skipped : 0.0, inserted : 0.0 }), tbl.get(12).replace(function(row) return { id : row["id"] }));
		assertAtom(({ deleted : 0.0, replaced : 1, unchanged : 0.0, errors : 0.0, skipped : 0.0, inserted : 0.0 }), tbl.get(12).replace(function(row) return { id : row["id"], a : row["id"] }));
		assertAtom(({ deleted : 1, replaced : 0.0, unchanged : 0.0, errors : 0.0, skipped : 0.0, inserted : 0.0 }), tbl.get(13).replace(function(row) return null));
		assertAtom(({ first_error : "Inserted object must have primary key `id`:\n{\n\t\\"a\\":\t1\n}", deleted : 0.0, replaced : 0.0, unchanged : 0.0, errors : 10, skipped : 0.0, inserted : 0.0 }), tbl.between(10, 20, { right_bound : "closed" }).replace(function(row) return { a : 1 }));
		assertAtom(({ first_error : "Primary key `id` cannot be changed (`{\n\t\"id\":\t1\n}` -> `{\n\t\"a\":\t1,\n\t\"id\":\t2\n}`).", deleted : 0.0, replaced : 0.0, unchanged : 0.0, errors : 1, skipped : 0.0, inserted : 0.0 }), tbl.get(1).replace({ id : 2, a : 1 }));
		assertAtom(({ first_error : "Inserted object must have primary key `id`:\n{\n\t\"a\":\t1\n}", deleted : 0.0, replaced : 0.0, unchanged : 0.0, errors : 1, skipped : 0.0, inserted : 0.0 }), tbl.get(1).replace({ a : 1 }));
		assertAtom(({ deleted : 0.0, replaced : 1, unchanged : 0.0, errors : 0.0, skipped : 0.0, inserted : 0.0 }), tbl.get(1).replace({ id : r.row["id"], a : "b" }));
		assertAtom(({ deleted : 0.0, replaced : 0.0, unchanged : 1, errors : 0.0, skipped : 0.0, inserted : 0.0 }), tbl.get(1).replace(r.row.merge({ a : "b" })));
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).replace(r.row.merge({ c : r.js("5") })));
		assertError("ReqlQueryLogicError", "Could not prove argument deterministic.  Maybe you want to use the non_atomic flag?", tbl.get(1).replace(r.row.merge({ c : tbl.nth(0) })));
		assertError("ReqlCompileError", "Unrecognized optional argument `foo`.", tbl.get(1).replace({  }, { foo : "bar" }));
		assertAtom(({ deleted : 99, replaced : 0.0, unchanged : 0.0, errors : 0.0, skipped : 0.0, inserted : 0.0 }), tbl.replace(function(row) return null));
		assertAtom(1, tbl.get("sdfjk").replace({ id : "sdfjk" })["inserted"]);
		assertAtom(1, tbl.get("sdfjki").replace({ id : "sdfjk" })["errors"]);
		assertAtom(({ deleted : 0.0, replaced : 0.0, unchanged : 0.0, errors : 0.0, skipped : 1, inserted : 0.0 }), tbl.get("non-existant").replace(null));
	}
}