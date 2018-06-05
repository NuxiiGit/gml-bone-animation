gml_pragma("global","global.sk_globalVar_structureType_dsMap = noone;");
#macro sk_struct_types global.sk_globalVar_structureType_dsMap
/// @desc creates a structure type
/// @param type
/// @param size
/// @param constructor
/// @param destructor
var sk_t = sk_struct_types;
if(!ds_exists(sk_t,ds_type_map)){
	sk_struct_types = ds_map_create();
	sk_t = sk_struct_types;
}
var sk_type = noone;
if(ds_map_exists(sk_t,argument0)){
	sk_type = sk_t[? argument0];
} else {
	sk_type = ds_map_create();
	ds_map_add_map(sk_t,argument0,sk_type);
}
// set type data
sk_type[? "size"] = max(real(argument1),1);
sk_type[? "constructor"] = argument2;
sk_type[? "destructor"] = argument3;