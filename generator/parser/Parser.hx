package parser;

import haxe.macro.Expr.ExprDef;
import haxe.macro.Expr.Binop;
import haxe.macro.Expr.Unop;
using StringTools;

enum Token {
	TPOpen;
	TPClose;
	TBkOpen;
	TBkClose;
	TBrOpen;
	TBrClose;
	TDot;
	TColon;
	TSemicolon;
	TComma;
	
	TIn;
	TFor;
	TLambda;
	
	TBinop(op:Binop);
	TUnop(op:Unop);
	
	TNumber(v:String);
	TString(v:String);
	TIdent(v:String);
	
	TEof;
}

enum Expr {
	EConst(c:Const);
	EField(e:Expr, field:String);
	ECall(e:Expr, args:Array<Expr>);
	EArrayAccess(e:Expr, e1:Expr);
	EBinop(op:Binop, e1:Expr, e2:Expr);
	EUnop(op:Unop, post:Bool, e:Expr);
	ELambda(args:Array<String>, expr:Expr);
	EObjectDecl(fields:Array<{field:String, expr:Expr}>);
	EArrayDecl(values:Array<Expr>);
	EParenthesis(e:Expr);
	EBlock(e:Array<Expr>);
	EReturn(e:Expr);
	EFor(it:Expr, e:Expr);
	EIn(e1:Expr, e2:Expr);
}

enum Const {
	CIdent(v:String);
	CInt(v:String);
	CFloat(v:String);
	CString(v:String);
}

class Lexer extends hxparse.Lexer implements hxparse.RuleBuilder {
	static var buf:StringBuf;
	
	public static var tok = @:rule [
		"\\(" => TPOpen,
		"\\)" => TPClose,
		"[" => TBkOpen,
		"]" => TBkClose,
		"{" => TBrOpen,
		"}" => TBrClose,
		"\\+" => TBinop(OpAdd),
		"\\-" => TBinop(OpSub),
		"\\*" => TBinop(OpMult),
		"\\/" => TBinop(OpDiv),
		"\\%" => TBinop(OpMod),
		"\\=" => TBinop(OpAssign),
		"\\=\\=" => TBinop(OpEq),
		"\\>\\=" => TBinop(OpGte),
		"\\<\\=" => TBinop(OpLte),
		"\\>" => TBinop(OpGt),
		"\\<" => TBinop(OpLt),
		"\\!\\=" => TBinop(OpNotEq),
		"\\&" => TBinop(OpAnd),
		"\\~" => TUnop(OpNot),
		"," => TComma,
		";" => TSemicolon,
		":" => TColon,
		"\\." => TDot,
		"for" => TFor,
		"in" => TIn,
		"True" => TIdent("true"),
		"False" => TIdent("false"),
		"None" => TIdent("null"),
		"lambda" => TLambda,
		"-?(([1-9][0-9]*)|0)(\\.[0-9]+)?([eE][\\+\\-]?[0-9]?)?" => TNumber(lexer.current),
		'"' => {
			buf = new StringBuf();
			lexer.token(string);
			TString(buf.toString());
		},
		"'" => {
			buf = new StringBuf();
			lexer.token(string2);
			TString(buf.toString());
		},
		"[\r\n\t ]" => lexer.token(tok),
		"[a-z_][a-zA-Z0-9_]*" => TIdent(lexer.current),
		"" => TEof,
	];

	public static var string = @:rule [
		"\\\\\\\\" => {
			buf.add("\\\\");
			lexer.token(string);
		},
		"\\\\" => {
			buf.add("\\");
			lexer.token(string);
		},
		"\\\\\"" => {
			buf.add('"');
			lexer.token(string);
		},
		'"' => lexer.curPos().pmax,
		"[^\\\\\"]+" => {
			buf.add(lexer.current);
			lexer.token(string);
		}
	];
	
	public static var string2 = @:rule [
		"\\\\\\\\" => {
			buf.add("\\\\");
			lexer.token(string2);
		},
		"\\\\" => {
			buf.add("\\");
			lexer.token(string2);
		},
		'\\\\\'' => {
			buf.add("'");
			lexer.token(string2);
		},
		"'" => lexer.curPos().pmax,
		"[^\\\\']+" => {
			buf.add(lexer.current);
			lexer.token(string2);
		}
	];
}

class Parser extends hxparse.Parser<hxparse.LexerTokenSource<Token>, Token> implements hxparse.ParserBuilder {
	
	var src:String;
	
	public function new(input:byte.ByteData, sourceName:String) {
		src = cast (input, haxe.io.Bytes).toString();
		var lexer = new Lexer(input, sourceName);
		var ts = new hxparse.LexerTokenSource(lexer, Lexer.tok);
		super(ts);
	}
	
	public function parse()
		return expr();
		// try return expr() catch(e:Dynamic) {
		// 	trace('Unable to parse: $src');
		// 	throw e;
		// }
	
	function expr():Expr {
		return switch stream {
			case [TString(v)]: next(EConst(CString(v)));
			case [TIdent(i)]: next(EConst(CIdent(i)));
			case [TNumber(i)]: next(EConst(CFloat(i)));
			case [TBkOpen, a = arrDecl(), TBkClose]: next(EArrayDecl(a));
			case [TBrOpen, e = block(), TBrClose]:
				switch e {
					case EObjectDecl(_): next(e);
					case e: e;
				}
			case [TPOpen, e = paren(), TPClose]: next(e);
			case [TLambda, p = funcArgs(), TColon, e = expr()]:
				var e = switch e {
					case EBlock(exprs): switch exprs[exprs.length - 1] {
						case EReturn(e) | e: EReturn(e);
					}
					case _: EReturn(e);
				}
				ELambda(p, e);
		}
	}
	
	function next(e:Expr) {
		return switch stream {
			case [TDot]:
				switch stream {
					case [TIdent(f)]:
						next(EField(e, f));
				}
			case [TPOpen]:
				switch stream {
					case [args = params(), TPClose]:
						var index = -1;
						var fields = [];
						for(i in 0...args.length) switch args[i] {
							case EBinop(OpAssign, EConst(CIdent(name)), e2):
								if(index == -1) index = i;
								fields.push({field: '"$name"', expr: e2});
							default:
								if(index != -1) throw 'Named arguments are suppose to be grouped at the end';
						}
						if(index != -1) {
							args.splice(index, args.length);
							args.push(EObjectDecl(fields));
						}
						next(ECall(e, args));
					case _: unexpected();
				}
			case [TBkOpen]:
				switch stream {
					case [e1 = expr(), TBkClose]: next(EArrayAccess(e, e1));
					case _: unexpected();
				}
			case [TBinop(op), e2 = expr()]:
				EBinop(op, e, e2);
			case _: e;
		}
	}
	
	// function semicolon() {
	// 	switch stream {
	// 		case []
	// 	}
	// }
	
	function block() {
		return switch stream {
			case [TIdent(i)]: block2(i, CIdent(i));
			case [TString(s)]: block2(s, CString(s));
			case _: EObjectDecl([]);
		}
	}
	
	function block2(name, c) {
		return switch stream {
			case [TColon, e = expr(), l = parseObjDecl()]:
				l.unshift({field:name, expr: e});
				for(i in l) {
					inline function s(v:String) return i.field.startsWith(v);
					inline function e(v:String) return i.field.endsWith(v);
					if(!s('"') && !e('"') && !s('\'') && !e('\'')) i.field = '"${i.field}"';
				}
				EObjectDecl(l);
			// case _:
			// 	var e = next(EConst(c));
			// 	var _ = 
		} 
	}
	
	function parseObjDecl() {
		var acc = [];
		while(true) {
			switch stream {
				case [TComma]:
					switch stream {
						case [TIdent(id), TColon, e = expr()]: acc.push({field: id, expr: e});
						case [TString(id), TColon, e = expr()]: acc.push({field: id, expr: e});
						case _: break;
					}
				case _: break;
			}
		}
		return acc;
	}
	
	function funcArgs() {
		var ret = [];
		switch stream {
			case [TIdent(i)]: ret.push(i);
			case _: return [];
		}
		while(true) {
			switch stream {
				case [TComma, TIdent(i)]: ret.push(i);
				case _: break;
			}
		}
		return ret;
	}
	
	function paren() {
		var ret = [];
		switch stream {
			case [e = expr()]: ret.push(e);
			case _: unexpected();
		}
		while(true) {
			switch stream {
				case [TComma, e = expr()]: ret.push(e);
				case _: break;
			}
		}
		return ret.length > 1 ? EArrayDecl(ret) : EParenthesis(ret[0]);
	}
	
	function arrDecl() {
		var ret = [];
		switch stream {
			case [e = expr()]: ret.push(e);
			case _: return [];
		}
		while(true) {
			switch stream {
				case [TFor, i = expr(), TIn, e = expr()]: 
					return [EFor(EIn(i, e), ret[0])];
				case [TComma, e = expr()]: ret.push(e);
				case _: break;
			}
		}
		return ret;
	}
	
	function params() {
		var ret = [];
		switch stream {
			case [e = expr()]: ret.push(e);
			case _: return [];
		}
		while(true) {
			switch stream {
				case [TComma, e = expr()]: ret.push(e);
				case _: break;
			}
		}
		return ret;
	}
}

class Printer {
	public static function print(e:Expr) {
		return switch e {
			case EConst(c): const(c);
			case EField(e, field): print(e) + '.$field';
			case ECall(e, args): print(e) + '(' + [for(a in args) print(a)].join(', ') + ')';
			case EUnop(op, post, e): if(post) print(e) + unop(op) else unop(op) + print(e);
			case EBinop(op, e1, e2): print(e1) + binop(op) + print(e2);
			case ELambda(args, e): 'function(${args.join(", ")}) ' + print(e);
			case EObjectDecl(fields): '{' + [for(f in fields) f.field + ':' + print(f.expr)].join(', ') + '}';
			case EArrayDecl(fields): '[' + [for(e in fields) print(e)].join(', ') + ']';
			case EParenthesis(e): '(' + print(e) + ')';
			case EArrayAccess(e, e1): print(e) + '[' + print(e1) + ']';
			case EBlock(exprs): '{' + [for(e in exprs) print(e) + ';'].join(' ') + '}';
			case EReturn(e): 'return ' + print(e);
			case EFor(it, e): 'for(' + print(it) + ') ' + print(e);
			case EIn(e1, e2): print(e1) + ' in ' + print(e2);
		}
	}
	
	static function const(c:Const) 
		return switch c {
			case CFloat(v) | CInt(v) | CIdent(v): v;
			case CString(v): '"$v"';
		}
		
	static function binop(op:Binop) 
		return new haxe.macro.Printer().printBinop(op);
		
	static function unop(op:Unop) 
		return new haxe.macro.Printer().printUnop(op);
}

class Mapper {
	static var underscoreRegex = ~/_(\w)/gi;
	public static function map(e:Expr):haxe.macro.Expr {
		var def = switch e {
			case EConst(c): ExprDef.EConst(switch c {
				case CIdent(v): CIdent(v);
				case CFloat(v): CFloat(v);
				case CInt(v): CInt(v);
				case CString(v): CString(v);
			});
			case EField(e, field):
				field = switch field {
					case 'default' | 'do':
						// escape keywords
						field + '_';
					case v if(v.endsWith('_')): v.substr(0, v.length - 1);
					default:
						// convert snake_case to camelCase
						var f = field;
						var buf = new StringBuf();
						while (underscoreRegex.match(f)) {
							buf.add(underscoreRegex.matchedLeft());
							buf.add(underscoreRegex.matched(1).toUpperCase());
							f = underscoreRegex.matchedRight();
						}
						buf.add(f);
						buf.toString();
				} 
				ExprDef.EField(map(e), field);
			case ECall(e, args):
				// convert `r(value)` to `r.expr(value)`
				if(e.match(EConst(CIdent('r')))) e = EField(EConst(CIdent('r')), 'expr'); 
				ExprDef.ECall(map(e), args.map(map));
			case EBinop(op, e1, e2): ExprDef.EBinop(op, map(e1), map(e2));
			case EUnop(op, post, e): ExprDef.EUnop(op, post, map(e));
			case ELambda(args, e): ExprDef.EFunction(null, {
					args: args.map(function(a) return {name: a, meta: null, opt: null, type: macro:Expr, value: null}),
					expr: map(e),
					ret: macro:Expr,
				});
			case EObjectDecl(fields): ExprDef.EObjectDecl(fields.map(function(f) return {field: f.field, expr: map(f.expr)}));
			case EArrayDecl(fields): ExprDef.ECheckType({pos: null, expr:ExprDef.EArrayDecl(fields.map(map))}, macro:Array<Dynamic>);
			case EParenthesis(e): ExprDef.EParenthesis(map(e));
			case EArrayAccess(e, e1): ExprDef.EArray(map(e), map(e1));
			case EBlock(exprs): ExprDef.EBlock(exprs.map(map));
			case EReturn(e): ExprDef.EReturn(map(e));
			case EFor(it, e): ExprDef.EFor(map(it), map(e));
			case EIn(e1, e2): ExprDef.EIn(map(e1), map(e2));
		}
		return {expr: def, pos: null}
	}
}