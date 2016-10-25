package ;

import rethinkdb.RethinkDB.r;
import rethinkdb.*;
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
			var res = o.sure().asAtom();
			trace(res);
			release();
		});
		
		
		retain();
		r.expr([1,2,3]).map(function(v) return v * v).run(conn).handle(function(o) {
			var res = o.sure().asAtom();
			trace(res);
			release();
		});
		
		retain();
		r.expr([1,2,3]).map(function(v) return v > 2).run(conn).handle(function(o) {
			var res = o.sure().asAtom();
			trace(res);
			release();
		});
		
		retain();
		r.expr([1,2,3]).map(function(v) return v == v).run(conn).handle(function(o) {
			var res = o.sure().asAtom();
			trace(res);
			release();
		});
		
		retain();
		r.table('users').map(function(user) return user['age']).reduce(function(x, y) return x + y).run(conn).handle(function(o) {
			var res = o.sure().asAtom();
			trace(res);
			release();
		});
		
		retain();
		r.table('users').map(function(user) return user['age']).run(conn).handle(function(o) {
			var cursor:Cursor<Int> = o.sure();
			
			cursor.forEach(function(i) return true).handle(function(_) {
				release();
			});
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
		
		retain();
		r.table('users').changes().run(conn).handle(function(o) {
			var cursor:Cursor<Dynamic> = o.sure();
			var n = 0;
			cursor.forEach(function(o) {
				trace(o);
				if(n++ > 3) {
					release();
					return false;
				}
				return true;
			});
		});
		r.table('users').insert([{age:1234}]).run(conn).handle(function(o) {
			var res:{generated_keys:Array<String>} = o.sure().asAtom();
			var key = res.generated_keys[0];
			var n = 90;
			for(i in 0...5) {
				haxe.Timer.delay(function() r.table('users').get(key).update({age:n+i}).run(conn), i * 0);
			}
		});
		
	}
  
}