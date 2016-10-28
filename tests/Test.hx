package;

import rethinkdb.RethinkDB.r;
import rethinkdb.*;
import rethinkdb.reql.*;

using rethinkdb.Response.ResponseTools;
using tink.CoreApi;

// @:build(Macro.build())
class Test {
	var conn:Connection;
	var tbl:Expr;
	public function new() {
		conn = r.connect();
		// tbl = r.table('default_test').orderBy(Field('a')).pluck(['a']);
		test();
	}
	
	function test() {
		r.expr(1).default_(2).run(conn).asAtom().handle(function(o) trace(o.sure()));
		r.expr(null).default_(2).run(conn).asAtom().handle(function(o) trace(o.sure()));
	}
}