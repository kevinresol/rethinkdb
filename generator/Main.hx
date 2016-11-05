package;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;

using tink.CoreApi;
using haxe.io.Path;
using sys.io.File;
using asys.io.Process;
using sys.FileSystem;
using StringTools;

class Main {
	
	static var root = '../../rethinkdb/test/rql_test/src';
	static var tests = [];
	static var hparser:hscript.Parser;
	static var hinterp:hscript.Interp;
	
	static function main() {
		
		Future.ofMany(preprocess()).handle(function(_) {
			var start = haxe.Timer.stamp();
			
			hparser = new hscript.Parser();
			hparser.allowJSON = true;
			hinterp = new hscript.Interp();
			hinterp.variables.set('None', null);
			
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
			tests.sort(Reflect.compare);
			for(i in 0...tests.length) {
				src.insert(s + i + 1, '\t\t\tnew ' + tests[i] + '(conn),');
			}
			main.saveContent(src.join('\n'));
			
			var t = Std.int((haxe.Timer.stamp() - start) * 1000) / 1000;
			trace('Generated ${tests.length} tests in ${t}s');
		});
		
	}
		
	static function preprocess(path = '', ?futures:Array<Future<Noise>>) {
		#if skip_preprocess return []; #end
		
		if(futures == null) futures = [];
		for(p in ('$root/$path').readDirectory()) {
			if('$root/$path/$p'.isDirectory()) preprocess('$path/$p', futures);
			else {
				var args = ['../../rethinkdb/test/common/parsePolyglot.py', '$root/$path/$p'];
				trace(args);
				var proc = new Process('python3', args);
				futures.push(proc.stdout.all().map(function(b) {
					if(!'./yaml/$path'.exists()) './yaml/$path'.createDirectory();
					var content = b.sure().toString();
					content = content.substr(content.indexOf('\n') + 1);
					'./yaml/$path/$p'.saveContent(content);
					return Noise;
				}));
			}
		}
		return futures;
	}
		
	static function handleDirectory(path:String) {
		for(p in ('$root/$path').readDirectory()) {
			if('$root/$path/$p'.isDirectory()) handleDirectory('$path/$p');
			else if(p.indexOf('.') != p.lastIndexOf('.')) continue;
			else if(p == 'range.yaml') continue; // skip this, did some manual changes
			// else if(path.indexOf('datum') == -1) continue;
			// else if(p != 'object.yaml') continue;
			// else handleFile('$path/$p');
			else try handleFile('$path/$p') catch(e:Dynamic) {
				trace(e);
			}
		}
	}
	
	static function handleFile(path:String) {
		trace('handling $path');
		var yaml = 'yaml/$path'.getContent();
		var tests = hinterp.execute(hparser.parseString(yaml));
		var pack = path.substr(1).directory();
		var filename = path.withoutDirectory().withoutExtension();
		var name = 'Test' + filename.substr(0, 1).toUpperCase() + filename.substr(1);
		var exprs = [];
		
		var printer = parser.Parser.Printer;
		var mapper = parser.Parser.Mapper;
		
		var tables = [];
		if(tests.table_variable_name != null) {
			var names:String = tests.table_variable_name;
			tables = names.replace(', ', ' ').split(' ');
		}
		
		for(test in (tests.tests:Array<Dynamic>)) {
			// if(exprs.length > 3) break;
			var str:Dynamic = test.py == null ? test.cd : test.py;
			
			var out:String = 
				if(!Reflect.hasField(test, 'ot')) null;
				else if(test.ot == null) 'null';
				else if(test.ot.py != null) test.ot.py; 
				else if(test.ot.cd != null) test.ot.cd;
				else test.ot;
			if(out != null && out.startsWith('"(') && out.endsWith(')"')) out = out.substr(2, out.length - 4); 
			if(out != null && out.startsWith('\\"') && out.endsWith('\\"')) out = out.substr(1, out.length - 3) + '"'; 
			if(out != null && out.startsWith('\\\'') && out.endsWith('\\\'')) out = out.substr(1, out.length - 3) + "'"; 
			var def:String = test.def;
			// if(out == null) trace(test);
			if(str != null) {
				try {
					
					function add(str:String) {
						var parser = new parser.Parser(byte.ByteData.ofString(str), 'test');
						var expr = parser.parse();
						var parsed = printer.print(expr);
						var action = mapper.map(expr);
						
						var parser = new parser.Parser(byte.ByteData.ofString(out), 'test');
						var expr = parser.parse();
						var parsed = printer.print(expr);
						var assert = switch mapper.map(expr) {
							case {expr:ECall({expr: EConst(CIdent('err'))}, p)}: macro assertError(${p[0]}, ${p[1]}, $action);
							case {expr:ECall({expr: EConst(CIdent('err_regex'))}, p)}: macro assertErrorRegex(${p[0]}, ${p[1]}, $action);
							case {expr:ECall({expr: EConst(CIdent('int_cmp'))}, p)}: macro assertAtom(${p[0]}, $action);
							case {expr:ECall({expr: EConst(CIdent('float_cmp'))}, p)}: macro assertAtom(${p[0]}, $action);
							case e: macro assertAtom($e, $action);
						}
						// trace(out, new haxe.macro.Printer().printExpr(assert));
						exprs.push(macro @:await $assert);
					}
					
					if(Std.is(str, Array)) for(s in (str:Array<String>)) add(s);
					else add(str);
					
					// trace(str, new haxe.macro.Printer().printExpr(exprs[exprs.length - 1]));
					
				} catch(e:Dynamic) {
					// trace(out);
					trace(e);
					// keep going
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
		
		var tableIdents = tables.map(function(n) return {expr: EConst(CString(n)), pos: null});
		var tableVars = tables.map(function(n) {
			var i = {expr: EConst(CString(n)), pos: null};
			return {
				name: n,
				expr: macro r.db('test').table($i),
				type: null,
			}	
		});
		
		if(tables.length > 0) {
			exprs = [
				(macro var _tables = $a{tableIdents}),
				(macro @:await createTables(_tables)),
				{expr: EVars(tableVars), pos: null},
			].concat(exprs).concat([
				(macro @:await dropTables(_tables)),
			]);
		}
		exprs.push(macro return Noise);
		var cl = macro class $name extends TestBase {
			@:async override function test() $b{exprs};
		}
		
		cl.meta = [{name: ':await', pos: null}];
		
		var src = [
			'package ' + pack.replace('/', '.') + ';',
			'import rethinkdb.RethinkDB.r;',
			'import rethinkdb.reql.*;',
			'using tink.CoreApi;',
			'',
			new haxe.macro.Printer().printTypeDefinition(cl)
		];
		
		var folder = '../tests/$pack/';
		if(!folder.exists()) folder.createDirectory();
		'$folder/$name.hx'.saveContent(src.join('\n'));
		Main.tests.push('$folder/$name'.normalize().substr(9).replace('/', '.'));
	}
}

