package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

using tink.CoreApi;

abstract Options(Array<Named<Term>>) from Array<Named<Term>> to Array<Named<Term>> {
	
	@:from
	public static function fromStruct(o:{}):Options {
		return [for(field in Reflect.fields(o)) {
			var value = Reflect.field(o, field);
			new NamedWith(field, Std.is(value, Term) ? value : TDatum(DatumTools.ofAny(value)));
		}];
	}
}