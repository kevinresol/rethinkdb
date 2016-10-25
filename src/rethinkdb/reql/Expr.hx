package rethinkdb.reql;

import rethinkdb.Connection;
import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;
using tink.CoreApi;

@:forward
abstract Exprs(Array<Expr>) from Array<Expr> to Array<Expr> from Array<Term> to Array<Term> to TermArgs {
	@:from
	public static inline function ofSingle(v:Expr):Exprs
		return [v];
	@:from
	public static inline function ofInt(v:Int):Exprs
		return ofSingle(TDatum(v));
	@:from
	public static inline function ofFloat(v:Float):Exprs
		return ofSingle(TDatum(v));
	@:from
	public static inline function ofString(v:String):Exprs
		return ofSingle(TDatum(v));
	@:from
	public static inline function ofBool(v:Bool):Exprs
		return ofSingle(TDatum(v));
	@:from
	public static inline function ofInts(v:Array<Int>):Exprs
		return [for(i in v) TDatum(i)];
	@:from
	public static inline function ofFloats(v:Array<Float>):Exprs
		return [for(i in v) TDatum(i)];
	@:from
	public static inline function ofStrings(v:Array<String>):Exprs
		return [for(i in v) TDatum(i)];
	@:from
	public static inline function ofBools(v:Array<Bool>):Exprs
		return [for(i in v) TDatum(i)];
}

@:forward
abstract Expr(Term) from Term to Term {
	
	static var varId:Int = 1;
	
	public inline function new(term:Term)
		this = term;
		
	public function run(connection:Connection) {
		var query:Query = QStart(this);
		return connection.query(query) >> function(r) return new Response(r, connection, query);
	}
	
	@:from
	public static function ofFunc1(f:Expr->Expr):Expr {
		var argNums = [TDatum(varId++)];
		var var1 = TVar(argNums[0]);
		return TFunc([TMakeArray(argNums), f(var1)]);
	}
	
	@:from
	public static function ofFunc2(f:Expr->Expr->Expr):Expr {
		var argNums = [TDatum(varId++), TDatum(varId++)];
		var var1 = TVar(argNums[0]);
		var var2 = TVar(argNums[1]);
		return TFunc([TMakeArray(argNums), f(var1, var2)]);
	}
	
	@:from
	public static function ofFunc3(f:Expr->Expr->Expr->Expr):Expr {
		var argNums = [TDatum(varId++), TDatum(varId++), TDatum(varId++)];
		var var1 = TVar(argNums[0]);
		var var2 = TVar(argNums[1]);
		var var3 = TVar(argNums[2]);
		varId += 3;
		return TFunc([TMakeArray(argNums), f(var1, var2, var3)]);
	}
	
	@:from
	public static function ofBools(v:Array<Bool>):Expr
		return TMakeArray([for(i in v) TDatum(i)]);
	@:from
	public static inline function ofString(v:String):Expr
		return TDatum(v);
	@:from
	public static inline function ofFloat(v:Float):Expr
		return TDatum(v);
	@:from
	public static inline function ofBool(v:Bool):Expr
		return TDatum(v);
		
	@:op(A+B)
	public inline function opAdd(b:Expr):Expr
		return add(b);
	@:op(A-B)
	public inline function opSub(b:Expr):Expr
		return sub(b);
	@:op(A*B)
	public inline function opMul(b:Expr):Expr
		return mul(b);
	@:op(A/B)
	public inline function opDiv(b:Expr):Expr
		return div(b);
	@:op(A%B)
	public inline function opMod(b:Expr):Expr
		return mod(b);
	@:op(A==B)
	public inline function opEq(b:Expr):Expr
		return eq(b);
	@:op(A!=B)
	public inline function opNe(b:Expr):Expr
		return ne(b);
	@:op(A>B)
	public inline function opGt(b:Expr):Expr
		return gt(b);
	@:op(A>=B)
	public inline function opGe(b:Expr):Expr
		return ge(b);
	@:op(A<B)
	public inline function opLt(b:Expr):Expr
		return lt(b);
	@:op(A<=B)
	public inline function opLe(b:Expr):Expr
		return le(b);
	@:op(!A)
	public inline function opNot():Expr
		return not();
		
	@:arrayAccess
	public inline function opGetField(v:String)
		return getField(v);
		
	@:to
	public inline function toTerm():Term
		return this;
	
	// Accessing ReQL
	public inline function changes():Expr
		return TChanges(this);
	
	// Writing data
	public inline function update(v:ObjectOrFunction):Expr
		return TUpdate([this, v]);
	public inline function replace(v:ObjectOrFunction):Expr
		return TReplace([this, v]);
	public inline function delete():Expr
		return TDelete(this);
	
	// Selecting data
	public inline function between(lower:Expr, upper:Expr):Expr
		return TBetween([this, lower, upper]);
	public inline function filter(f:Expr->Expr):Expr
		return TFilter([this, (f:Expr)]);
	
	// Joins
	public inline function innerJoin(v:Expr, f:Expr->Expr->Expr):Expr
		return TInnerJoin([this, v, (f:Expr)]);
	public inline function outerJoin(v:Expr, f:Expr->Expr->Expr):Expr
		return TOuterJoin([this, v, (f:Expr)]);
	public inline function eqJoin(v:Expr, table:Table):Expr
		return TEqJoin([this, v, table]);
	public inline function zip():Expr
		return TZip(this);
	
	// Transformation
	public inline function map(f:Expr->Expr):Expr
		return TMap([this, (f:Expr)]);
		
	public inline function withFields(v:Array<String>):Expr
		return TWithFields({
			var args = [this];
			for(i in v) args.push(TDatum(i));
			args;
		});
	public inline function concatMap(f:Expr->Expr):Expr
		return TConcatMap([this, (f:Expr)]);
	public inline function orderBy(v:OrderByOptions):Expr
		return TOrderBy([this].concat(v));
	public inline function skip(v:Int):Expr
		return TSkip([this, TDatum(v)]);
	public inline function limit(v:Int):Expr
		return TLimit([this, TDatum(v)]);
	public inline function slice(start:Int, ?end:Int):Expr
		return TSlice({
			var args = [this, TDatum(start)];
			if(end != null) args.push(TDatum(end));
			args;
		});
	public inline function nth(v:Int):Expr
		return TNth([this, TDatum(v)]);
	public inline function offsetsOf(v:Datum):Expr // TODO: also accepts predicate function
		return TOffsetsOf([this, TDatum(v)]);
	public inline function isEmpty():Expr
		return TIsEmpty(this);
	public inline function union(v:Array<Expr>):Expr
		return TUnion(this.concat(v));
	public inline function sample(v:Int):Expr
		return TSample([this, TDatum(v)]);
		
	// Agregation
	public inline function group(v:String):Expr
		return TGroup([this, TDatum(v)]);
	public inline function ungroup():Expr
		return TUngroup(this);
	public inline function reduce(f:Expr->Expr->Expr):Expr
		return TReduce([this, (f:Expr)]);
	public inline function fold(base:Expr, f:Expr->Expr->Expr):Expr
		return TFold([this, base, (f:Expr)]);
	public inline function count():Expr // TODO: optional arguments
		return TCount(this);
	public inline function sum():Expr // TODO: optional arguments
		return TSum(this);
	public inline function avg():Expr
		return TAvg(this);
	public inline function min():Expr
		return TMin(this);
	public inline function max():Expr
		return TMax(this);
	public inline function distinct():Expr
		return TDistinct(this);
	public inline function contains(v:String):Expr
		return TContains(this.concat(v));
		
	// Document manipulation
	public inline function pluck(v:Array<String>):Expr
		return TPluck(this.concat(v));
	public inline function without(v:Array<Expr>):Expr
		return TWithout(this.concat(v));
	public inline function merge(v:Array<Expr>):Expr
		return TMerge(this.concat(v));
	public inline function append(v:Expr):Expr
		return TAppend([this, v]);
	public inline function prepend(v:Expr):Expr
		return TPrepend([this, v]);
	public inline function difference(v:Exprs):Expr
		return TDifference(this.concat(v));
	public inline function setInsert(v:Expr):Expr
		return TSetInsert([this, v]);
	public inline function setUnion(v:Exprs):Expr
		return TSetUnion(this.concat(v));
	public inline function setIntersection(v:Exprs):Expr
		return TSetIntersection(this.concat(v));
	public inline function setDifference(v:Exprs):Expr
		return TSetDifference(this.concat(v));
	public inline function getField(v:String):Expr
		return TGetField([this, TDatum(v)]);
	public inline function hasFields(v:Exprs):Expr
		return THasFields(this.concat(v));
	public inline function insertAt(offset:Int, v:Expr):Expr
		return TInsertAt([this, TDatum(offset), v]);
	public inline function spliceAt(offset:Int, v:Exprs):Expr
		return TSpliceAt([this, TDatum(offset)].concat(v));
	public inline function deleteAt(offset:Int, ?end:Int):Expr
		return TDeleteAt({
			var args = [this, TDatum(offset)];
			if(end != null) args.push(TDatum(end));
			args;
		});
	public inline function changeAt(offset:Int, v:Expr):Expr
		return TChangeAt([this, TDatum(offset), v]);
	public inline function keys():Expr
		return TKeys(this);
	public inline function values():Expr
		return TValues(this);

	// String manipulation
	public inline function match(v:String):Expr
		return TMatch([this, TDatum(v)]);
	public inline function split(?sep:String, ?max:Int):Expr
		return TMatch({
			var args = [this];
			if(sep != null) args.push(TDatum(sep));
			if(max != null) args.push(TDatum(max));
			args;
		});
	public inline function upcase():Expr
		return TUpcase(this);
	public inline function downcase():Expr
		return TDowncase(this);
	
	// Math and logic
	public inline function add(v:Expr):Expr
		return TAdd([this, v]);
	public inline function sub(v:Expr):Expr
		return TSub([this, v]);
	public inline function mul(v:Expr):Expr
		return TMul([this, v]);
	public inline function div(v:Expr):Expr
		return TDiv([this, v]);
	public inline function mod(v:Expr):Expr
		return TMod([this, v]);
	public inline function and(v:Expr):Expr
		return TAnd([this, v]);
	public inline function or(v:Expr):Expr
		return TOr([this, v]);
	public inline function eq(v:Expr):Expr
		return TEq([this, v]);
	public inline function ne(v:Expr):Expr
		return TNe([this, v]);
	public inline function gt(v:Expr):Expr
		return TGt([this, v]);
	public inline function ge(v:Expr):Expr
		return TGe([this, v]);
	public inline function lt(v:Expr):Expr
		return TLt([this, v]);
	public inline function le(v:Expr):Expr
		return TLe([this, v]);
	public inline function not():Expr
		return TNot(this);
	public inline function round():Expr
		return TRound(this);
	public inline function ceil():Expr
		return TCeil(this);
	public inline function floor():Expr
		return TFloor(this);
		
	// Dates and times
	public inline function inTimezone(v:String):Expr
		return TInTimezone([this, TDatum(v)]);
	public inline function timezone():Expr
		return TTimezone(this);
	public inline function during(start:Expr, end:Expr):Expr
		return TDuring([this, start, end]);
	public inline function date():Expr
		return TDate(this);
	public inline function timeOfDay():Expr
		return TTimeOfDay(this);
	public inline function year():Expr
		return TYear(this);
	public inline function month():Expr
		return TMonth(this);
	public inline function day():Expr
		return TDay(this);
	public inline function dayOfWeek():Expr
		return TDayOfWeek(this);
	public inline function dayOfYear():Expr
		return TDayOfYear(this);
	public inline function hours():Expr
		return THours(this);
	public inline function minutes():Expr
		return TMinutes(this);
	public inline function seconds():Expr
		return TSeconds(this);
	public inline function toISO8601():Expr
		return TToIso8601(this);
	public inline function toEpochTime():Expr
		return TToEpochTime(this);
	
	// Control structures
	public inline function do_(f:Expr):Expr
		return TFuncall([f, this]);
	public inline function branch(ifTrue:Expr, ifFalse:Expr):Expr
		return TBranch([this, ifTrue, ifFalse]);
	public inline function forEach(f:Expr->Expr):Expr
		return TForEach([this, (f:Expr)]);
	public inline function default_(v:Datum):Expr // TODO: function form
		return TForEach([this, TDatum(v)]);
	public inline function coerceTo(v:Expr):Expr // TODO: figure this out...
		throw 'Not implemented';
	public inline function typeOf():Expr
		return TTypeOf(this);
	public inline function info():Expr
		return TInfo(this);
	public inline function toJsonString():Expr
		return TToJsonString(this);
	public inline function toJson():Expr
		return TToJsonString(this);
	
	// Geospatial commands
	public inline function circle(point:Expr, radius:Expr)
		return TCircle([this, point, radius]);
	public inline function distance(v:Expr)
		return TDistance([this, v]);
	public inline function fill()
		return TFill(this);
	public inline function toGeojson():Expr
		return TToGeojson(this);
	public inline function includes(v:Expr):Expr
		return TIncludes([this, v]);
	public inline function intersects(v:Expr):Expr
		return TIntersects([this, v]);
	public inline function polygonSub(v:Expr):Expr
		return TPolygonSub([this, v]);
}

enum OrderByKind {
	Field(v:String);
	Index(v:String);
	Term(v:Term);
}

abstract OrderByOptions(Array<OrderByKind>) from Array<OrderByKind> {
	@:from
	public static function ofString(v:String):OrderByOptions return [Field(v)];
	@:from
	public static function ofTerm(v:Term):OrderByOptions return [Term(v)];
	@:from
	public static function ofSingle(v:OrderByKind):OrderByOptions return [v];
	@:to
	public function toTerms():Array<Term>
		return [for(i in this) switch i {
			case Field(v): TDatum(v);
			case Index(v): TDatum(DObject([new NamedWith('index', DString(v))]));
			case Term(v): v;
		}];
}