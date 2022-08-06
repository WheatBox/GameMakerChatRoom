socket = network_create_socket(network_socket_tcp);
network_set_config(network_config_connect_timeout,10000);
connect = network_connect_raw(socket,client_connect_server,6510);
if(connect < 0) {
	show_message("连接服务器失败！");
	game_end();
} else {
	name = "";
	while(name == "") {
		name = get_string("你的名字是？","");
	}
	sendmes = "";//表示服务器要发送的数据内容，刚开始不发送的时候先清零

	getmes = "";
	
	var buf;
	buf = buffer_create(10000,buffer_fixed,4);
	buffer_write(buf,buffer_string,"&name=" + name);
	network_send_raw(socket,buf,buffer_get_size(buf));
	buffer_delete(buf);
	Talkstr_list = ds_list_create();
	
	textbox_1 = textbox_create(0,352,640,24,"","Enter text",120,true,false);
	textbox_set_font(textbox_1,font1,c_white,18,1.5);
}
//a = 0;