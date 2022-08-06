var map = async_load;
var type = ds_map_find_value(map,"type");
var buf;
if(type == network_type_connect) {
	client = ds_map_find_value(map,"socket");//client指服务端接受的客户端id
	ip = ds_map_find_value(map,"ip");
	ds_list_add(socket_list,client);
	ds_list_add(ip_list,ip);
}

if(type == network_type_data) {
	// buffer_create(10000,buffer_fixed,4);
	buf = ds_map_find_value(map,"buffer");
	getmes = buffer_read(buf,buffer_string);
	if(string_copy(getmes,0,6) == "&name=") {
		var gotname = string_copy(getmes,7,string_length(getmes) - 6);
		ds_list_add(name_list,gotname);
		sendmes = "&coly=" + gotname + "进入了聊天室";
	} else {
		sendmes = getmes;
	}
	for(var i = 0; i < ds_list_size(socket_list); i++) {
		buf = buffer_create(10000,buffer_fixed,4);
		buffer_write(buf,buffer_string,sendmes);
		network_send_raw(socket_list[| i],buf,buffer_get_size(buf));
		buffer_delete(buf);
	}
}

if(type == network_type_disconnect) {
	var index = ds_list_find_index(socket_list,ds_map_find_value(map,"socket"));
	var exitname = name_list[| index];
	sendmes = "&coly=" + exitname + "离开了聊天室";
	for(var i = 0; i < ds_list_size(socket_list); i++) {
		buf = buffer_create(10000,buffer_fixed,4);
		buffer_write(buf,buffer_string,sendmes);
		network_send_raw(socket_list[| i],buf,buffer_get_size(buf));
		buffer_delete(buf);
	}
	ds_list_delete(socket_list,index);
	ds_list_delete(name_list,index);
	ds_list_delete(ip_list,index);
}