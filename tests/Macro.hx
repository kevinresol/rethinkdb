package;

import haxe.macro.Context;
import haxe.macro.Expr;
import yaml.Yaml;
import yaml.Parser;

using sys.io.File;
using tink.MacroApi;
using StringTools;

class Macro {
	
	static var FUNC_RE = ~/(function\([^)]*\))\s*{(\s*[^}]*\s*)}/gi;
	
	public static function build() {
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();
		var tests = Yaml.read("../rethinkdb/test/rql_test/src/default.yaml", Parser.options().useObjects());
		var exprs = [];
		for(test in (tests.tests:Array<Dynamic>)) {
			if(exprs.length > 3) break;
			var str:String = test.js == null ? test.cd : test.js;
			var out:String = test.ot;
			if(str == null) continue;
			try {
				str = str.replace('do(', 'do_(');
				str = str.replace('default', 'default_');
				str = FUNC_RE.replace(str, "$1{$2;}");
				var expr = Context.parse(str, pos);
				var out = Context.parse(out, pos);
				expr = macro $expr.run(conn).asAtom().handle(function(o) {
					var actual = o.sure();
					var expected = $out;
					if(actual != expected) trace("Expected " + expected + " but got " + actual);
				});
				exprs.push(expr);
			} catch(e:Dynamic) {
				trace('Cannot parse $str: $e');
			}
		}
		
		
		fields.push({
			access: [],
			name: 'test',
			kind: FFun({
				args: [],
				expr: macro $b{exprs},
				ret: null,
			}),
			pos: pos,
		});
		return fields;
	}
}