/// @desc gets or sets a property
/// @param attachment
/// @param [y]
var sk_struct = argument[0];
if(argument_count<2){
	// get
	return sk_struct[SK_ATTACHMENT_POINT.Y];
}	// set
	sk_struct[@ SK_ATTACHMENT_POINT.Y] = real(argument[1]);
	return undefined;