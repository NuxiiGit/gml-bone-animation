__SK_OBJECT_DEBUG_ASSERT_EXISTENCE = !sk_bone_exists(argument0);
#macro SK_BONE_DEBUG_BONES (1<<0)
#macro SK_BONE_DEBUG_INHERITANCE (1<<1)
#macro SK_BONE_DEBUG_SIMPLE (1<<2)
#macro SK_BONE_DEBUG_NAMES (1<<3)
#macro SK_BONE_DEBUG_VECTORS (1<<4)
#macro SK_BONE_DEBUG_BAD_TRANSFORMS (1<<5)
#macro SK_BONE_DEBUG_EX_STRUCTURE (SK_BONE_DEBUG_BONES|SK_BONE_DEBUG_INHERITANCE|SK_BONE_DEBUG_VECTORS)
#macro SK_BONE_DEBUG_EX_DATA (SK_BONE_DEBUG_NAMES|SK_BONE_DEBUG_BAD_TRANSFORMS)
/// @desc renders an abstract structure representing the bone
/// @param bone
/// @param x
/// @param y
/// @param xscale
/// @param yscale
/// @param rotation
/// @param debugArgs
var sk_bone = argument0;
var sk_draw_x = argument1;
var sk_draw_y = argument2;
var sk_draw_xscale = argument3;
var sk_draw_yscale = argument4;
var sk_draw_rot = argument5;
var sk_draw_sine = (sk_draw_rot==0) ? 0 : dsin(sk_draw_rot);
var sk_draw_cosine = (sk_draw_rot==0) ? 1 : dcos(sk_draw_rot);
// transform by global scale
var sk_bone_xlocal = sk_bone[sk_data_bone.worldX]*sk_draw_xscale;
var sk_bone_ylocal = sk_bone[sk_data_bone.worldY]*sk_draw_yscale;
var sk_bone_m00 = sk_bone[sk_data_bone.m00]*sk_draw_xscale; // x component of x
var sk_bone_m01 = sk_bone[sk_data_bone.m01]*sk_draw_yscale; // y component of x
var sk_bone_m10 = sk_bone[sk_data_bone.m10]*sk_draw_xscale; // x component of y
var sk_bone_m11 = sk_bone[sk_data_bone.m11]*sk_draw_yscale; // y component of y
// transform by global rotation
var sk_bone_xworld = sk_draw_x+sk_bone_xlocal*sk_draw_cosine+sk_bone_ylocal*sk_draw_sine;
var sk_bone_yworld = sk_draw_y-sk_bone_xlocal*sk_draw_sine+sk_bone_ylocal*sk_draw_cosine;
var sk_bone_w00 = (sk_bone_m00*sk_draw_cosine)+(sk_bone_m01*sk_draw_sine);
var sk_bone_w01 = (sk_bone_m00*-sk_draw_sine)+(sk_bone_m01*sk_draw_cosine);
var sk_bone_w10 = (sk_bone_m10*sk_draw_cosine)+(sk_bone_m11*sk_draw_sine);
var sk_bone_w11 = (sk_bone_m10*-sk_draw_sine)+(sk_bone_m11*sk_draw_cosine);
// start primitive
draw_primitive_begin(pr_linelist);
var V_COLOUR = c_black;
var V_ALPHA = 1;
if(argument6&SK_BONE_DEBUG_BONES){
	V_COLOUR = $00ff00;
	var sk_bone_len = max(sk_bone[sk_data_bone.length],1);
	var sk_bone_width = max(sk_bone_len,5)*0.05;
	// draw a bone in its familiar shape
	var sk_bone_xlen = sk_bone_xworld+sk_bone_w00*sk_bone_len;
	var sk_bone_ylen = sk_bone_yworld+sk_bone_w01*sk_bone_len;
	if(argument6&SK_BONE_DEBUG_SIMPLE){
		draw_vertex_colour(sk_bone_xworld,sk_bone_yworld,V_COLOUR,V_ALPHA);
		draw_vertex_colour(sk_bone_xlen,sk_bone_ylen,V_COLOUR,V_ALPHA);
	} else {
		var sk_bone_xpositive = sk_bone_xworld+sk_bone_w00*sk_bone_len*0.2+sk_bone_w10*sk_bone_width;
		var sk_bone_ypositive = sk_bone_yworld+sk_bone_w01*sk_bone_len*0.2+sk_bone_w11*sk_bone_width;
		var sk_bone_xnegative = sk_bone_xworld+sk_bone_w00*sk_bone_len*0.2-sk_bone_w10*sk_bone_width;
		var sk_bone_ynegative = sk_bone_yworld+sk_bone_w01*sk_bone_len*0.2-sk_bone_w11*sk_bone_width;
		draw_vertex_colour(sk_bone_xworld,sk_bone_yworld,V_COLOUR,V_ALPHA);
		draw_vertex_colour(sk_bone_xpositive,sk_bone_ypositive,V_COLOUR,V_ALPHA); // #1
		draw_vertex_colour(sk_bone_xworld,sk_bone_yworld,V_COLOUR,V_ALPHA);
		draw_vertex_colour(sk_bone_xnegative,sk_bone_ynegative,V_COLOUR,V_ALPHA); // #2
		draw_vertex_colour(sk_bone_xpositive,sk_bone_ypositive,V_COLOUR,V_ALPHA);
		draw_vertex_colour(sk_bone_xlen,sk_bone_ylen,V_COLOUR,V_ALPHA); // #3
		draw_vertex_colour(sk_bone_xnegative,sk_bone_ynegative,V_COLOUR,V_ALPHA);
		draw_vertex_colour(sk_bone_xlen,sk_bone_ylen,V_COLOUR,V_ALPHA); // #4
	}
}
if(argument6&SK_BONE_DEBUG_INHERITANCE){
	V_COLOUR = $ff00ff;
	var sk_parentData = sk_bone[sk_data_bone.parent];
	if(sk_parentData!=undefined){
		// get parent bone transforms
		var sk_parent_xlocal = sk_parentData[sk_data_bone.worldX]*sk_draw_xscale;
		var sk_parent_ylocal = sk_parentData[sk_data_bone.worldY]*sk_draw_yscale;
		var sk_parent_m00 = sk_parentData[sk_data_bone.m00]*sk_draw_xscale; // x component of x
		var sk_parent_m01 = sk_parentData[sk_data_bone.m01]*sk_draw_yscale; // y component of x
	//	var sk_parent_m10 = sk_parentData[sk_data_bone.m10]*sk_draw_xscale; // x component of y // not required
	//	var sk_parent_m11 = sk_parentData[sk_data_bone.m11]*sk_draw_yscale; // y component of y
		// transform by global rotation
		var sk_parent_xworld = sk_draw_x+sk_parent_xlocal*sk_draw_cosine+sk_parent_ylocal*sk_draw_sine;
		var sk_parent_yworld = sk_draw_y-sk_parent_xlocal*sk_draw_sine+sk_parent_ylocal*sk_draw_cosine;
		var sk_parent_w00 = (sk_parent_m00*sk_draw_cosine)+(sk_parent_m01*sk_draw_sine);
		var sk_parent_w01 = (sk_parent_m00*-sk_draw_sine)+(sk_parent_m01*sk_draw_cosine);
	//	var sk_parent_w10 = (sk_parent_m10*sk_draw_cosine)+(sk_parent_m11*sk_draw_sine); // not required
	//	var sk_parent_w11 = (sk_parent_m10*-sk_draw_sine)+(sk_parent_m11*sk_draw_cosine);
		var sk_parent_length = max(sk_parentData[sk_data_bone.length],1);
		draw_vertex_colour(sk_parent_xworld+sk_parent_w00*sk_parent_length,sk_parent_yworld+sk_parent_w01*sk_parent_length,V_COLOUR,V_ALPHA);
		draw_vertex_colour(sk_bone_xworld,sk_bone_yworld,V_COLOUR,V_ALPHA);
	}
}
V_COLOUR = $ffffff;
var sk_bone_len = max(sk_bone[sk_data_bone.length],1);
var sk_bone_xtext = sk_bone_xworld+sk_bone_w00*sk_bone_len*0.5;
var sk_bone_ytext = sk_bone_yworld+sk_bone_w01*sk_bone_len*0.5;
if(argument6&SK_BONE_DEBUG_NAMES){	
	draw_text(sk_bone_xtext,sk_bone_ytext,sk_bone_get_name(sk_bone));
}
if(argument6&SK_BONE_DEBUG_BAD_TRANSFORMS){
	draw_text(sk_bone_xtext,sk_bone_ytext+10,sk_bone[sk_data_bone.invalidAppliedTransform]);
}
if(argument6&SK_BONE_DEBUG_VECTORS){
	var unit = max(sk_bone[sk_data_bone.length]*0.5,1);
	V_COLOUR = $0000ff;
	draw_vertex_colour(sk_bone_xworld,sk_bone_yworld,V_COLOUR,V_ALPHA);
	draw_vertex_colour(sk_bone_xworld+sk_bone_w00*unit,sk_bone_yworld+sk_bone_w01*unit,V_COLOUR,V_ALPHA);
	V_COLOUR = $ff0000;
	draw_vertex_colour(sk_bone_xworld,sk_bone_yworld,V_COLOUR,V_ALPHA);
	draw_vertex_colour(sk_bone_xworld+sk_bone_w10*unit,sk_bone_yworld+sk_bone_w11*unit,V_COLOUR,V_ALPHA);
}
draw_primitive_end();