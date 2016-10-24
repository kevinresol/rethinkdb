package rethinkdb;

import rethinkdb.reql.*;
import tink.protocol.rethinkdb.Term;

class RethinkDB {
	public static var r:RethinkDB = new RethinkDB();
	
	public function new() {
		
	}
	
	public function connect(?options):Connection {
		return new Connection(options);
	}
	
	public inline function db(name:String):Db
		return TDb([name]);
	public inline function table(name:String):Table
		return TTable([name]);
}