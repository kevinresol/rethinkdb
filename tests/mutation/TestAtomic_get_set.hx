package mutation;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
class TestAtomic_get_set extends TestBase {
	override function test() {
		assertAtom(({ first_error : "Duplicate primary key `id`:\n{\n\t\"id\":\t0\n}\n{\n\t\"id\":\t0\n}", changes : [{ old_val : { id : 0 }, new_val : { id : 0 }, error : "Duplicate primary key `id`:\n{\n\t\"id\":\t0\n}\n{\n\t\"id\":\t0\n}" }] }), tbl.insert({ id : 0 }, { "return_changes" : "always" }).pluck("changes", "first_error"));
		assertAtom(({ first_error : "a", changes : [{ old_val : { id : 0, x : 2 }, new_val : { id : 0, x : 2 }, error : "a" }] }), tbl.get(0).replace(function(y) return { x : r.error("a") }, { "return_changes" : "always" }).pluck("changes", "first_error"));
		assertAtom(({ first_error : "Inserted object must have primary key `id`:\n{\n\t\"x\":\t1\n}", changes : [{ new_val : { id : 0 }, old_val : { id : 0 }, error : "Inserted object must have primary key `id`:\n{\n\t\"x\":\t1\n}" }, { new_val : { id : 1 }, old_val : { id : 1 }, error : "Inserted object must have primary key `id`:\n{\n\t\"x\":\t1\n}" }] }), tbl.replace({ x : 1 }, { "return_changes" : "always" }).pluck("changes", "first_error").do_(function(d) return d.merge({ changes : d["changes"].orderBy(function(a) return a["old_val"]["id"]) })));
	}
}