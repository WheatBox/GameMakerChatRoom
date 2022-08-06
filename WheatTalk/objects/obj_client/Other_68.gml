map = async_load;
type = ds_map_find_value(map,"type");
server = ds_map_find_value(map,"id");
var buf;

if(type == network_type_data) {
	// buffer_create(10000,buffer_fixed,4);
	buf = ds_map_find_value(map,"buffer");
	getmes = buffer_read(buf,buffer_string);
	if(string_copy(getmes,0,6) != "&sern=") {
		ds_list_add(Talkstr_list,getmes);
		if(ds_list_size(Talkstr_list) > 20) ds_list_delete(Talkstr_list,0);
	}
}