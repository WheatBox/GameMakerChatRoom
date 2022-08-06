var map = async_load;
if(map[? "id"] == broadcast_server) {
	var ip = map[? "ip"];
	var buff = map[? "buffer"];
	var name = buffer_read(buff,buffer_string);
	var index = ds_list_find_index(server_list,ip);
	if(index < 0) {
		if(string_copy(name,0,6) == "&sern=") {
			ds_list_add(server_list,ip);
			ds_list_add(server_names,string_copy(name,7,string_length(name) - 6));
		}
	}
}