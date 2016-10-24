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
		
		
		// var expr = new Expr(TMakeArray([1,2,3]));
		// expr = expr.map(function(v) return v.mul(1));
		// trace(expr.toString());
		// retain();
		// expr.run(conn).handle(function(o) {
		// 	trace(o.sure());
		// 	release();
		// });
		
		var expr = r.table('users').map(function(user) return user.getField('age')).reduce(function(x, y) return x + y);
		trace(expr.toString());
		
		retain();
		expr.run(conn).handle(function(o) {
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