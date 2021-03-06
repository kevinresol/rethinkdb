package rethinkdb;

import tink.streams.Stream;
import tink.streams.StreamStep;
import tink.protocol.rethinkdb.Query;
import rethinkdb.response.Response;

using tink.CoreApi;

class Cursor<T> extends Generator<T> {
	var items:Array<T> = [];
	var firstResponse:Response;
	var connection:Connection;
	var query:Query;
	var nextResponse:Surprise<Response, Error>;
	var threshold = 1;
	
	public function new(res, con, q) {
		firstResponse = res;
		addResponse(res);
		connection = con;
		query = q;
		super(nextStep);
	}
	
	public function nextStep():Future<StreamStep<T>> {
		return Future.async(function(cb) {
			function next() cb(Data(items.shift()));
			if(items.length > 0) {
				next();
				return;
			} else if(!firstResponse.isFeed()) {
				cb(End);
			} else if(nextResponse == null) {
				nextResponse = connection.query(new Query(QContinue(firstResponse.token)));
				nextResponse.handle(function(o) switch o {
					case Success(res): addResponse(res); nextResponse = null; next();
					case Failure(f): trace('fail');
				});
			} else {
				// TODO: hm...
				trace('hm...');
			}
		});
	}
	
	public function toArray() {
		var data = [];
		return forEach(function(v) {
			data.push(v);
			return true;
		}) >> function(_) return data;
	}
	
	function addResponse(res:Response) {
		var values = res.type != SUCCESS_ATOM ? res.response : res.response[0];
		threshold = values.length;
		for(i in values) items.push(i);
	}
	
}