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
		r.expr([1,2,3]).map(function(v) return v * v).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		retain();
		r.expr([1,2,3]).map(function(v) return v > 2).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.expr([1,2,3]).map(function(v) return v == v).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.table('users').map(function(user) return user['age']).reduce(function(x, y) return x + y).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.uuid().run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.do_(function(a:Expr, b:Expr, c:Expr) return a + b + c, [1,2,3]).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
		retain();
		r.expr(100).do_(function(a:Expr) return a * a).run(conn).handle(function(o) {
			trace(o.sure());
			release();
		});
		
	}
  
}