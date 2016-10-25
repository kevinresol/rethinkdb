package rethinkdb.reql;

import rethinkdb.reql.util.*;
import tink.protocol.rethinkdb.Term;

@:forward
abstract SingleSelection(Expr) from Term to Term {
	
	// Writing data
	public inline function update(v:ObjectOrFunction):Expr
		return TUpdate([this, v]);
	public inline function replace(v:ObjectOrFunction):Expr
		return TReplace([this, v]);
	public inline function delete():Expr
		return TDelete(this);
}