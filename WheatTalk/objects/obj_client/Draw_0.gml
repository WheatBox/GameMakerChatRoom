for(var i = 0; i < ds_list_size(Talkstr_list); i++) {
	var skiptext = 0;
	draw_set_color(c_white);
	if(string_copy(Talkstr_list[| i],0,6) == "&coly=") {
		draw_set_color(c_yellow);
		skiptext = 6;
	}
	var got = string_copy(Talkstr_list[| i],skiptext + 1,string_length(Talkstr_list[| i]) - skiptext);
	draw_text(0,16 * i,got);
}