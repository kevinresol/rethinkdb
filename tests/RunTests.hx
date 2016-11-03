package ;

import deepequal.DeepEqual.*;
import rethinkdb.RethinkDB.r;
import rethinkdb.*;
import rethinkdb.reql.*;
import rethinkdb.response.*;

using RethinkDBApi;
using tink.CoreApi;

class RunTests {

	static function main() {
		
		var conn = r.connect();
		var tests = [
			new TestDefault(conn),
			new TestTemp(conn),
		];
		
		Future.ofMany([for(test in tests) test.run()]).handle(function(outcomes) {
			var errors = [];
			for(o in outcomes) switch o {
				case Success(_):
				case Failure(e): errors = errors.concat(e);
			}
			if(errors.length > 0) for(e in errors) trace(e);
			Sys.exit(errors.length);
		});
	}
}