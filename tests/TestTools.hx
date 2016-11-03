package;

import deepequal.DeepEqual.*;
import rethinkdb.*;
import rethinkdb.response.ReqlError;

using rethinkdb.response.Response;
using tink.CoreApi;

class TestTools {
	public static function assertError<T>(s:Surprise<T, Error>, e:ReqlError, ?pos:haxe.PosInfos) {
		s.handle(function(o) switch o {
			case Success(_): throw new Error("Unexpected failure", pos);
			case Failure(f): try {
				var err:ReqlError = f.data;
				compare(e.getIndex(), err.getIndex());
				compare(e.getParameters()[0], err.getParameters()[0]);
			} catch(err:String) throw new Error(err, pos);
		});
	}
	public static function assertAtom<T>(s:Surprise<Atom<T>, Error>, e:T, ?pos:haxe.PosInfos) {
		s.handle(function(o) switch o {
			case Success(v): try compare(e, v) catch(err:String) throw new Error(err, pos);
			case Failure(f): throw new Error('Unexpected error $f', pos);
		});
	}
}