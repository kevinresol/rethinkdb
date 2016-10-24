package rethinkdb.reql;

import rethinkdb.Connection;
import tink.protocol.rethinkdb.Query;
import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;
using tink.CoreApi;
@:forward
abstract Expr(Term) from Term to Term {
	
	public inline function new(term:Term)
		this = term;
	
	@:from
	public static inline function ofString(v:String):Expr
		return TDatum(v);
	
	@:from
	public static inline function ofFloat(v:Float):Expr
		return TDatum(v);
	
	@:from
	public static inline function ofBool(v:Bool):Expr
		return TDatum(v);
	
	public inline function run(connection:Connection)
		return connection.query(QStart(this));
		
	@:op(A+B)
	public inline function opAdd(b:Expr):Expr
		return add(b);
	
	
	// Transformation
	public inline function map(f:Expr->Expr):Expr
		return TMap([this, new Func(f)]);
		
	public inline function withFields(v:Array<String>):Expr
		return TWithFields({
			var args = [this];
			for(i in v) args.push(TDatum(i));
			args;
		});
	public inline function concatMap(f:Expr->Expr):Expr
		return TConcatMap([this, new Func(f)]);
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
		return TIsEmpty([this]);
	public inline function union(v:Array<Expr>):Expr
		return TUnion([this].concat(v));
	public inline function sample(v:Int):Expr
		return TSample([this, TDatum(v)]);
		
	// Agregation
	public inline function group(v:String):Expr
		return TGroup([this, TDatum(v)]);
	public inline function ungroup():Expr
		return TUngroup([this]);
	public inline function reduce(f:Expr->Expr->Expr):Expr // TODO
		return TReduce([this, new Func(f)]);
	
	
	
	public inline function getField(v:String):Expr
		return TGetField([this, TDatum(v)]);
	public inline function add(v:Expr):Expr
		return TAdd([this, v]);
	public inline function mul(v:Expr):Expr
		return TMul([this, v]);
	
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