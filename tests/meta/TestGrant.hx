package meta;
import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;
using tink.CoreApi;

@:await class TestGrant extends TestBase {
	@:async
	override function test() {
		@:await assertError(err("ReqlOpFailedError", "Expected a boolean or nu" + "ll for `read`, got 1.", []), r.grant("test_user", { "read" : 1 }));
		@:await assertError(err("ReqlOpFailedError", "Unexpected key(s) `invalid`.", []), r.grant("test_user", { "invalid" : "invalid" }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : { "read" : true, "write" : true, "config" : true, "connect" : true }, "new_val" : null }] }, r.grant("test_user", { "read" : null, "write" : null, "config" : null, "connect" : null }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : null, "new_val" : { "read" : true, "write" : true, "config" : true, "connect" : true } }] }, r.grant("test_user", { "read" : true, "write" : true, "config" : true, "connect" : true }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : { "read" : true, "write" : true, "config" : true, "connect" : true }, "new_val" : { "read" : false, "write" : false, "config" : true, "connect" : true } }] }, r.grant("test_user", { "read" : false, "write" : false }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : { "read" : false, "write" : false, "config" : true, "connect" : true }, "new_val" : { "write" : false, "config" : true, "connect" : true } }] }, r.grant("test_user", { "read" : null }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : { "write" : false, "config" : true, "connect" : true }, "new_val" : { "write" : false, "config" : true, "connect" : true } }] }, r.grant("test_user", {  }));
		r.dbCreate("database");
		@:await assertError(err("ReqlOpFailedError", "The `connect` permission is only valid at the global scope.", []), r.db("database").grant("test_user", { "connect" : true }));
		@:await assertError(err("ReqlOpFailedError", "Unexpected key(s) `invalid`.", []), r.db("database").grant("test_user", { "invalid" : "invalid" }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : null, "new_val" : { "read" : true, "write" : true, "config" : true } }] }, r.db("database").grant("test_user", { "read" : true, "write" : true, "config" : true }));
		r.db("database").tableCreate("table");
		@:await assertError(err("ReqlOpFailedError", "The `connect` permission is only valid at the global scope.", []), r.db("database").table("table").grant("test_user", { "connect" : true }));
		@:await assertError(err("ReqlOpFailedError", "Unexpected key(s) `invalid`.", []), r.db("database").table("table").grant("test_user", { "invalid" : "invalid" }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : null, "new_val" : { "read" : true, "write" : true, "config" : true } }] }, r.db("database").table("table").grant("test_user", { "read" : true, "write" : true, "config" : true }));
		@:await assertError(err("ReqlOpFailedError", "The permissions of the user `admin` can\'t be modified.", []), r.grant("admin", { "config" : false }));
		@:await assertError(err("ReqlOpFailedError", "The permissions of the user `admin` can\'t be modified.", []), r.db("database").grant("admin", { "config" : false }));
		@:await assertError(err("ReqlOpFailedError", "The permissions of the user `admin` can\'t be modified.", []), r.db("database").table("table").grant("admin", { "config" : false }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : null, "new_val" : { "read" : true, "write" : true } }] }, r.db("rethinkdb").grant("test_user", { "read" : true, "write" : true }));
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : null, "new_val" : { "read" : true } }] }, r.db("rethinkdb").table("stats").grant("test_user", { "read" : true }));
		r.db("rethinkdb").table("permissions").filter({ "user" : "test_user" }).delete();
		@:await assertError(err("ReqlPermissionError", "User `test_user` does not have the required `read` permission.", []), r.grant("test_user", { "read" : true }));
		r.grant("test_user", { "read" : true, "write" : true });
		@:await assertError(err("ReqlPermissionError", "User `test_user` does not have the required `read` permission.", []), r.grant("test_user", { "read" : true }));
		r.grant("test_user", { "read" : null, "write" : null });
		r.db("rethinkdb").grant("test_user", { "read" : true, "write" : true });
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : null, "new_val" : { "read" : true } }] }, r.grant("test_user", { "read" : true }));
		r.db("rethinkdb").grant("test_user", { "read" : null, "write" : null });
		r.db("rethinkdb").table("permissions").grant("test_user", { "read" : true, "write" : true });
		@:await assertAtom({ "granted" : 1, "permissions_changes" : [{ "old_val" : { "read" : true }, "new_val" : { "read" : true, "write" : true } }] }, r.grant("test_user", { "write" : true }));
		return Noise;
	}
}