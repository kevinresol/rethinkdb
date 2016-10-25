package rethinkdb;

import haxe.io.Bytes;
import rethinkdb.reql.Expr;
import rethinkdb.reql.Db;
import rethinkdb.reql.Table;
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
		
	// Transformation
	public inline function map(v:Expr, f:Expr->Expr):Expr
		return TMap([v, (f:Expr)]);
	public inline function union(v:Exprs):Expr
		return TUnion(v);
		
	// Aggregation
	public inline function group(v:Expr, f:Expr):Expr
		return TGroup([v, f]);
	public inline function reduce(v:Expr, f:Expr->Expr->Expr):Expr
		return TReduce([v, (f:Expr)]);
	public inline function fold(s:Expr, base:Expr, f:Expr->Expr->Expr):Expr
		return TFold([s, base, (f:Expr)]);
	public inline function count(v:Expr):Expr // TODO: optional arguments
		return TCount(v);
	public inline function sum(v:Expr):Expr // TODO: optional arguments
		return TSum(v);
	public inline function avg(v:Expr):Expr
		return TAvg(v);
	public inline function min(v:Expr):Expr
		return TMin(v);
	public inline function max(v:Expr):Expr
		return TMax(v);
	public inline function distinct(v:Expr):Expr
		return TDistinct(v);
	public inline function contains(s:Expr, v:Expr):Expr
		return TContains([s, v]);
	
	// Document manipulation
	public var row:Expr = TImplicitVar([]);
	public inline function literal(v:Expr):Expr
		return TLiteral(v);
	public inline function object(v:Exprs):Expr
		return TObject(v);
	
	// Math and logic
	public inline function add(v1:Expr, v2:Expr):Expr
		return TAdd([v1, v2]);
	public inline function sub(v1:Expr, v2:Expr):Expr
		return TSub([v1, v2]);
	public inline function mul(v1:Expr, v2:Expr):Expr
		return TMul([v1, v2]);
	public inline function div(v1:Expr, v2:Expr):Expr
		return TDiv([v1, v2]);
	public inline function mod(v1:Expr, v2:Expr):Expr
		return TMod([v1, v2]);
	public inline function and(v1:Expr, v2:Expr):Expr
		return TAnd([v1, v2]);
	public inline function or(v1:Expr, v2:Expr):Expr
		return TOr([v1, v2]);
	public inline function eq(v1:Expr, v2:Expr):Expr
		return TEq([v1, v2]);
	public inline function ne(v1:Expr, v2:Expr):Expr
		return TNe([v1, v2]);
	public inline function gt(v1:Expr, v2:Expr):Expr
		return TGt([v1, v2]);
	public inline function ge(v1:Expr, v2:Expr):Expr
		return TGe([v1, v2]);
	public inline function lt(v1:Expr, v2:Expr):Expr
		return TLt([v1, v2]);
	public inline function le(v1:Expr, v2:Expr):Expr
		return TLe([v1, v2]);
	public inline function not(v:Expr):Expr
		return TNot(v);
	public inline function random():Expr
		return TRandom([]);
	public inline function round(v:Expr):Expr
		return TRound([v]);
	public inline function ceil(v:Expr):Expr
		return TCeil([v]);
	public inline function floor(v:Expr):Expr
		return TFloor([v]);
		
	// Dates and times
	public inline function now():Expr
		return TNow([]);
	public inline function time(year:Int, month:Int, day:Int, hour = 0, minute = 0, second = 0, timezone = 'Z'):Expr
		return TTime([TDatum(year), TDatum(month), TDatum(day), TDatum(hour), TDatum(minute), TDatum(second), TDatum(timezone)]);
	public inline function epochTime(seconds:Int):Expr
		return TEpochTime([TDatum(seconds)]);
	public inline function ISO8601(v:String):Expr
		return TIso8601([TDatum(v)]);
	public inline function sunday():Expr
		return TSunday([]);
	public inline function monday():Expr
		return TMonday([]);
	public inline function tuesday():Expr
		return TTuesday([]);
	public inline function wednesday():Expr
		return TWednesday([]);
	public inline function thursday():Expr
		return TThursday([]);
	public inline function friday():Expr
		return TFriday([]);
	public inline function saturday():Expr
		return TSaturday([]);
	public inline function january():Expr
		return TJanuary([]);
	public inline function february():Expr
		return TFebruary([]);
	public inline function march():Expr
		return TMarch([]);
	public inline function april():Expr
		return TApril([]);
	public inline function may():Expr
		return TMay([]);
	public inline function june():Expr
		return TJune([]);
	public inline function july():Expr
		return TJuly([]);
	public inline function august():Expr
		return TAugust([]);
	public inline function september():Expr
		return TSeptember([]);
	public inline function october():Expr
		return TOctober([]);
	public inline function november():Expr
		return TNovember([]);
	public inline function december():Expr
		return TDecember([]);
	
		
	// Control structures
	public inline function args(v:Exprs):Expr
		return TArgs(v);
	public inline function binary(v:Bytes):Expr
		return TBinary([TDatum(v)]);
	public inline function do_(f:Expr, ?a:Exprs):Expr
		return TFuncall(a == null ? [f] : [f].concat(a));
	public inline function branch(v:Expr, t:Expr, f:Expr):Expr
		return TBranch([v, t, f]);
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
	public inline function typeOf(v:Expr):Expr
		return TTypeOf(v);
	public inline function info(v:Expr):Expr
		return TInfo(v);
	public inline function json(v:String):Expr
		return TJson(v);
	public inline function http(v:String):Expr
		return THttp(v);
	public inline function uuid(?v:String):Expr
		return TUuid(v == null ? [] : v);
	
	// Geospatial commands
	public inline function circle(point:Expr, radius:Expr):Expr
		return TCircle([point, radius]);
	public inline function distance(v1:Expr, v2:Expr):Expr
		return TDistance([v1, v2]);
	public inline function geojson(v:Expr):Expr
		return TGeojson(v);
	public inline function intersects(v1:Expr, v2:Expr):Expr
		return TIntersects([v1, v2]);
	public inline function line(v:Exprs):Expr
		return TLine(v);
	public inline function point(long:Expr, lat:Expr):Expr
		return TPoint([long, lat]);
	public inline function polygon(v:Exprs):Expr
		return TPolygon(v.concat([v[v.length - 1]]));
	
	// Administration
	public inline function grant(s:Expr, v:Expr, opt:Expr):Expr
		return TGrant([s, v, opt]);
	public inline function wait(s:Expr, ?opt:Expr):Expr
		return TWait({
			var args = [s];
			if(opt != null) args.push(opt);
			args;
		});
		
	// Others
	public inline function asc(v:Expr):Expr
		return TAsc(v);
	public inline function desc(v:Expr):Expr
		return TDesc(v);
	public var maxval:Expr = TMaxval([]);
	public var minval:Expr = TMinval([]);
	
}