package;

import deepequal.DeepEqual.*;
import rethinkdb.*;
import rethinkdb.reql.ReqlError;

using rethinkdb.Response;
using tink.CoreApi;

class TestTools {
	public static function assertError<T>(s:Surprise<T, ReqlError>, e:ReqlError, ?pos:haxe.PosInfos) {
		s.handle(function(o) switch o {
			case Success(_): throw new Error("Expected failure", pos);
			case Failure(f): try compare(e, f) catch(err:String) throw new Error(err, pos);
		});
	}
	public static function assertAtom<T>(s:Surprise<Atom<T>, ReqlError>, e:T, ?pos:haxe.PosInfos) {
		s.handle(function(o) switch o {
			case Success(v): try compare(e, v) catch(err:String) throw new Error(err, pos);
			case Failure(f): throw new Error('Unexpected error $f', pos);
		});
	}
}