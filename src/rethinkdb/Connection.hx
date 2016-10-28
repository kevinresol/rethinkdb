package rethinkdb;

import haxe.io.Bytes;
import tink.tcp.Connection as TcpConnection;
import tink.protocol.rethinkdb.Client;
import tink.protocol.rethinkdb.Query;
// import tink.protocol.rethinkdb.RawResponse;
import tink.protocol.rethinkdb.Response as ProtocolResponse;
import tink.streams.Accumulator;
import tink.streams.Stream;

using rethinkdb.Response;
using tink.CoreApi;

class Connection {
	var client:Client;
	var sender:Accumulator<Bytes>;
	var received:Signal<ProtocolResponse>;
	
	public function new(?options:ConnectionOptions) {
		if(options == null) options = {};
		if(options.host == null) options.host = 'localhost';
		if(options.port == null) options.port = 28015;
		
		client = new Client(TcpConnection.establish({host: options.host, port: options.port}));
		sender = new Accumulator();
		var incoming = client.connect(sender);
		var trigger = Signal.trigger();
		received = trigger;
		incoming.forEach(function(bytes) {
			trigger.trigger(bytes);
			return true;
		});
	}
	
	public function close():Surprise<Noise, Error> {
		throw "Not implemented";
	}
	
	public function reconnect():Surprise<Connection, Error>  {
		throw "Not implemented";
	}
	
	public function use(dbName:String) {
		throw "Not implemented";
	}
	
	public function server() {
		return query(QServerInfo).asAtom();
	}
	
	public function query(query:Query):Surprise<Response, Error> {
		var future = Future.async(function(cb) {
			var link:CallbackLink = null;
			link = received.handle(function(res) {
				if(res.token == query.token) {
					res.convert({rawTime: false, rawBinary: false, rawGroups: false});
					cb(Success(new Response(res, this, query)));
					link.dissolve();
				}
			});
		});
		sender.yield(Data(query.toBytes()));
		return future;
	}
}

// enum Format

typedef ConnectionOptions = {
	?host:String,
	?port:Int,
}