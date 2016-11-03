package rethinkdb.reql;

import tink.protocol.rethinkdb.Term;
import tink.protocol.rethinkdb.Datum;

using tink.CoreApi;

abstract Options(Array<Named<Term>>) from Array<Named<Term>> to Array<Named<Term>> {
	
	@:from
	public static function fromStruct(v:{}):Options {
		return [for(field in Reflect.fields(v)) {
			new NamedWith(field, TDatum(DatumTools.ofAny(Reflect.field(v, field))));
		}];
	}
}