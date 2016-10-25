package rethinkdb.reql;

import rethinkdb.Connection;
import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;
using tink.CoreApi;

@:forward
abstract Expr(Term) from Term to Term {
	
	static var varId:Int = 1;
	
	public inline function new(term:Term)
		this = term;
		
	public inline function run(connection:Connection)
		return connection.query(QStart(this));
	
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
		
	@:arrayAccess
	public inline function opGetField(v:String)
		return getField(v);
		
	@:to
	public inline function toTerm():Term
		return this;
	
	
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
	public inline function row():Expr
		return TImplicitVar(this);
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
	public inline function difference(v:TermArgs):Expr
		return TDifference(this.concat(v));
	public inline function setInsert(v:Expr):Expr
		return TSetInsert([this, v]);
	public inline function setUnion(v:TermArgs):Expr
		return TSetUnion(this.concat(v));
	public inline function setIntersection(v:TermArgs):Expr
		return TSetIntersection(this.concat(v));
	public inline function setDifference(v:TermArgs):Expr
		return TSetDifference(this.concat(v));
	public inline function getField(v:String):Expr
		return TGetField([this, TDatum(v)]);
	public inline function hasFields(v:TermArgs):Expr
		return THasFields(this.concat(v));
	public inline function insertAt(offset:Int, v:Expr):Expr
		return TInsertAt([this, TDatum(offset), v]);
	public inline function spliceAt(offset:Int, v:TermArgs):Expr
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
	public inline function literal(v:Expr):Expr
		return TLiteral([this, v]);
	public inline function object(v:Array<Named<Datum>>):Expr
		return TObject([this, TDatum(DObject(v))]);

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
	public inline function and(v:Array<Bool>):Expr
		return TAnd(this.concat(v));
	public inline function or(v:Array<Bool>):Expr
		return TOr(this.concat(v));
	public inline function eq(v:TermArgs):Expr
		return TEq(this.concat(v));
	public inline function ne(v:TermArgs):Expr
		return TNe(this.concat(v));
	public inline function gt(v:Array<Float>):Expr
		return TGt(this.concat(v));
	public inline function ge(v:Array<Float>):Expr
		return TGe(this.concat(v));
	public inline function lt(v:Array<Float>):Expr
		return TLt(this.concat(v));
	public inline function le(v:Array<Float>):Expr
		return TLe(this.concat(v));
	public inline function not(v:Bool):Expr
		return TNot([this, TDatum(v)]);
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
	public inline function do_(?args:TermArgs, func:Expr):Expr
		return TFuncall({
			var a = [this, func];
			if(args != null) a = a.concat(args);
			a;
		});
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