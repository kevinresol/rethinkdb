package rethinkdb;

import haxe.io.Bytes;
import rethinkdb.reql.*;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

class RethinkDB {
	public static var r:RethinkDB = new RethinkDB();
	
	public function new() {
		
	}
	
	public function connect(?options):Connection {
		return new Connection(options);
	}
	
	
	// Manipulating databases
	public inline function dbCreate(name:String):Expr
		return TDbCreate(name);
	public inline function dbDrop(name:String):Expr
		return TDbDrop(name);
	public inline function dbList():Expr
		return TDbDrop([]);
		
	// Manipulating tables
	public inline function tableCreate(name:String):Expr
		return TTableCreate(name);
		
	// Selecting data
	public inline function db(name:String):Db
		return TDb(name);
	public inline function table(name:String):Table
		return TTable(name);
		
	// 
	public inline function random():Expr
		return TRandom([]);
		
	// Dates and times
	public inline function now():Expr
		return TNow([]);
	public inline function time(year:Int, month:Int, day:Int, hour = 0, minute = 0, second = 0, timezone = 'Z'):Expr
		return TTime([TDatum(year), TDatum(month), TDatum(day), TDatum(hour), TDatum(minute), TDatum(second), TDatum(timezone)]);
	public inline function epochTime(seconds:Int):Expr
		return TEpochTime([TDatum(seconds)]);
	public inline function ISO8601(v:String):Expr
		return TIso8601([TDatum(v)]);
		
	// Control structures
	public inline function args(v:TermArgs):Expr
		return TArgs(v);
	public inline function binary(v:Bytes):Expr
		return TBinary([TDatum(v)]);
		
	// Control structures
	public inline function do_(?args:TermArgs, func:Expr):Expr
		return TFuncall({
			var a = [func];
			if(args != null) a = a.concat(args);
			a;
		});
	public inline function range(?start:Int, ?end:Int):Expr
		return TRange({
			var args = [];
			if(start != null) args.push(TDatum(start));
			if(end != null) args.push(TDatum(end));
			args;
		});
	public inline function error(v:String):Expr
		return TError(v);
	public inline function expr(v:Datum):Expr
		return TDatum(v);
	public inline function js(v:String):Expr
		return TJavascript(v);
	public inline function info(v:Expr):Expr
		return TInfo(v);
	public inline function json(v:String):Expr
		return TJson(v);
	public inline function http(v:String):Expr
		return THttp(v);
	public inline function uuid(?v:String):Expr
		return TUuid(v == null ? [] : v);
	
	// Geospatial commands
	public inline function circle(point:Point, radius:Float):Geometry
		return TCircle([point, TDatum(radius)]);
	public inline function distance(v1:Geometry, v2:Geometry):Number
		return TDistance([v1, v2]);
	public inline function geojson(v:Dynamic):Geometry
		return TGeojson([TDatum(Datum.fromDynamic(v))]);
	public inline function intersects(v1:Expr, v2:Geometry):Expr
		return TIntersects([(v1:Term), v2]);
	public inline function line(v:Array<Point>):Line
		return TLine(v);
	public inline function point(long:Float, lat:Float):Point
		return TPoint([TDatum(long), TDatum(lat)]);
	public inline function polygon(v:Array<Point>):Polygon
		return TPolygon(v.concat([v[v.length - 1]]));
	
}