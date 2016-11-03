package;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;
import yaml.Yaml;
import yaml.Parser;

using sys.io.File;
using StringTools;

class Main {
	static function main() {
		var tests = Yaml.read("../../rethinkdb/test/rql_test/src/default.yaml", Parser.options().useObjects());
		var name = 'TestTemp';
		var exprs = [];
		
		var printer = parser.Parser.Printer;
		var mapper = parser.Parser.Mapper;
		
		for(test in (tests.tests:Array<Dynamic>)) {
			// if(exprs.length > 3) break;
			var str:String = test.py == null ? test.cd : test.py;
			var out:String = Std.string(test.ot);
			var def:String = test.def;
			// trace(str, out);
			if(str != null) {
				try {
					
					var parser = new parser.Parser(byte.ByteData.ofString(str), 'test');
					var expr = parser.parse();
					var parsed = printer.print(expr);
					var action = mapper.map(expr);
					
					var parser = new parser.Parser(byte.ByteData.ofString(out), 'test');
					var expr = parser.parse();
					var parsed = printer.print(expr);
					var assert = switch mapper.map(expr) {
						case {expr:ECall({expr: EConst(CIdent('err'))}, p)}: macro assertError(${p[0]}, ${p[1]}, $action);
						case e: macro assertAtom($e, $action);
					}
					
					exprs.push(assert);
					
				} catch(e:Dynamic) {
					// trace(e);
					// continue
				}
			}
			if(def != null) {
				var parser = new parser.Parser(byte.ByteData.ofString(def), 'test');
				var expr = parser.parse();
				var parsed = printer.print(expr);
				var defExpr = switch mapper.map(expr).expr {
					case EBinop(OpAssign, {expr: EConst(CIdent(name))}, expr): EVars([{
						expr: expr,
						name: name,
						type: null,
					}]);
					default: throw 'unhandled def: $def';
				}
				exprs.push({expr: defExpr, pos: null});
			}
			
		}
		
		var cl = macro class $name extends TestBase {
			override function test() $b{exprs}
		}
		
		var src = [
			'import rethinkdb.RethinkDB.r;',
			'import rethinkdb.reql.*;',
			new haxe.macro.Printer().printTypeDefinition(cl)
		];
		'../tests/$name.hx'.saveContent(src.join('\n'));
	}
}
