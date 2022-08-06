if(mouse_y < 16) {
	var conip = get_string("要连接的服务器ip:","");
	if(conip != "") {
		client_connect_server = conip;
		room_goto(RoomC);
	}
} else if(mouse_y < (ds_list_size(server_list) + 1) * 16) {
	client_connect_server = server_list[| mouse_y / 16 - 1];
	room_goto(RoomC);
}