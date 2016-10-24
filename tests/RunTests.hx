package ;

import rethinkdb.RethinkDB.r;
import rethinkdb.reql.Expr;
using tink.CoreApi;

class RunTests {

	static var count = 0;
	static function retain() count ++;
	static function release() if(--count == 0) travix.Logger.exit(0);
	
	static function main() {
		var conn = r.connect();
		
		retain();
		r.db('rethinkdb').table('users').get('admin').run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		
		retain();
		r.expr([1,2,3]).map(function(v) return v.mul(v)).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.table('users').map(function(user) return user.getField('age')).reduce(function(x, y) return x + y).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.uuid().run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		var f:Expr = function(a) return (1:Expr);
		retain();
		r.do_([1], f).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		// retain();
		// r.db('test').table('tink_protocol').map(function(r) return r.mul(r)).run(conn).handle(function(o) {
		// 	trace(o.sure());
		// 	release();
		// });
	}
  
}