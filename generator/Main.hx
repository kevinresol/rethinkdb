package;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;
import yaml.Yaml;
import yaml.Parser;

using haxe.io.Path;
using sys.io.File;
using sys.FileSystem;
using StringTools;

class Main {
	
	static var root = '../../rethinkdb/test/rql_test/src';
	static var tests = [];
	
	static function main() {
		
		handleDirectory('');
		
		var main = '../tests/RunTests.hx';
		var src = main.getContent().split('\n');
		var s = -1, e = -1;
		for(i in 0...src.length) {
			var line = src[i];
			if(line.indexOf('// >>>>') != -1) s = i;
			if(line.indexOf('// <<<<') != -1) e = i;
			if(s != -1 && e != -1) break;
		}
		
		src.splice(s + 1, e - s - 1);
		for(i in 0...tests.length) {
			src.insert(s + i + 1, '\t\t\tnew ' + tests[i] + '(conn),');
		}
		main.saveContent(src.join('\n'));
	}
		
	static function handleDirectory(path:String) {
		for(p in ('$root/$path').readDirectory()) {
			if('$root/$path/$p'.isDirectory()) handleDirectory('$path/$p');
			else if(p.indexOf('.') != p.lastIndexOf('.')) continue;
			else try handleFile('$path/$p') catch(e:Dynamic) {
				trace(e);
			}
		}
	}
	
	static function handleFile(path:String) {
		trace('handling $path');
		var tests = Yaml.read('$root/$path', Parser.options().useObjects());
		var pack = path.substr(1).directory();
		var filename = path.withoutDirectory().withoutExtension();
		var name = 'Test' + filename.substr(0, 1).toUpperCase() + filename.substr(1);
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
					trace(e);
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
			'package ' + pack.replace('/', '.') + ';',
			'import rethinkdb.RethinkDB.r;',
			'import rethinkdb.reql.*;',
			new haxe.macro.Printer().printTypeDefinition(cl)
		];
		
		var folder = '../tests/$pack/';
		if(!folder.exists()) folder.createDirectory();
		'$folder/$name.hx'.saveContent(src.join('\n'));
		Main.tests.push('$folder/$name'.normalize().substr(9).replace('/', '.'));
	}
}
