//if(keyboard_check_pressed(ord("Y"))) {
//	sendmes = name + ":" + get_string("你想发送什么消息？","");
//	if(sendmes != name + ":") {
//		var buf;
//		buf = buffer_create(10000,buffer_fixed,4);
//		buffer_write(buf,buffer_string,sendmes);
//		network_send_packet(socket,buf,buffer_get_size(buf));
//		buffer_delete(buf);
//	}
//}
if(keyboard_check_pressed(vk_enter) || (keyboard_check(vk_alt) && keyboard_check_pressed(ord("S")))) {
	sendmes = name + ":" + textbox_return(textbox_1);
	//instance_destroy(textbox_1);
	//textbox_1 = textbox_create(0,352,640,24,"","Enter text",120,true,false);
	//textbox_set_font(textbox_1,font1,c_white,18,1.5);
	if(sendmes != name + ":") {
		var buf;
		buf = buffer_create(10000,buffer_fixed,4);
		buffer_write(buf,buffer_string,sendmes);
		network_send_raw(socket,buf,buffer_get_size(buf));
		buffer_delete(buf);
	}
}
//room_speed = 30;
//a++;
//var buf = buffer_create(1,buffer_grow,1);
//buffer_write(buf,buffer_string,string(a));
//network_send_raw(socket,buf,buffer_get_size(buf));
//buffer_delete(buf);