draw_text(0,0,"当前聊天室内用户：");
for(var i = 0; i < ds_list_size(ip_list) && i < ds_list_size(name_list); i++) {
	draw_text(0,16 * (i + 1),string(ip_list[| i]) + " " + name_list[| i]);
}