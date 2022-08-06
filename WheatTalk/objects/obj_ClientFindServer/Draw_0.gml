draw_text(0,0,"如果下方没有出现服务器列表，可以试着点击我以手动连接");
for(var i = 0; i < ds_list_size(server_list); i++) {
	draw_text(0,16 * (i + 1),server_list[| i] + " " + server_names[| i]);
}