package;

import rethinkdb.RethinkDB.r;
import rethinkdb.reql.*;

class TestDefault extends TestBase {
	override function test() {
		assertAtom(1, r.expr(1).default_(2));
		assertAtom(2, r.expr(null).default_(2));
		assertAtom([0, 1, 2, 3], r.expr([0, 1, 2]).do_(function(e:Expr) return e.append(3)));
		assertAtom(3, r.do_(1, 2, function(x:Expr, y:Expr) return x + y));
		assertAtom(1, r.do_(1));
		assertError('ReqlQueryLogicError', 'Expected function with 2 arguments but found function with 1 argument.', r.do_(1, 2, function(x:Expr) return x));
		assertError('ReqlQueryLogicError', 'Expected function with 3 arguments but found function with 2 arguments.', r.do_(1, 2, 3, function(x:Expr, y:Expr) return x + y));
		assertError('ReqlQueryLogicError', 'Expected type ARRAY but found STRING.', r.expr('abc').do_(function(v:Expr) return v.append(3)));
		assertError('ReqlQueryLogicError', 'Expected type STRING but found NUMBER.', r.expr('abc').do_(function(v:Expr) return v + 3));
		assertError('ReqlQueryLogicError', 'Expected type STRING but found NUMBER.', r.expr('abc').do_(function(v:Expr) return v.add('def')).add(3));
		assertError('ReqlQueryLogicError', 'Expected function with 1 argument but found function with 2 arguments.', r.expr(0).do_(function(a:Expr, b:Expr) return a + b).add(3));
		
		
		assertAtom(1, r.branch(true, 1, 2));
		assertAtom(2, r.branch(false, 1, 2));
		assertAtom('c', r.branch(1, 'c', false));
		assertAtom([], r.branch(null, {}, []));
		assertError('ReqlQueryLogicError', 'Expected type DATUM but found DATABASE:', r.branch(r.db('test'), 1, 2));
		
	}
}