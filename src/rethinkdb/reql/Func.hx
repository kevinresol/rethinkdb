package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;

@:forward
abstract Func(Expr) from Expr to Expr to Term {
	static var varId:Int = 1;
	
	public inline function new(func:Func) this = func;
	
	@:from
	public static function ofFunc1(f:Expr->Expr):Func {
		var argNums = [TDatum(varId)];
		var var1 = TVar([TDatum(varId)]);
		varId++;
		return TFunc([TMakeArray(argNums), f(var1)]);
	}
	
	@:from
	public static function ofFunc2(f:Expr->Expr->Expr):Func {
		var argNums = [TDatum(varId), TDatum(varId + 1)];
		var var1 = TVar([TDatum(varId)]);
		var var2 = TVar([TDatum(varId + 1)]);
		varId += 2;
		return TFunc([TMakeArray(argNums), f(var1, var2)]);
	}
}