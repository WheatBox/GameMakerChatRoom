servername = get_string("你想给该聊天室取个什么名字？","");

broadcast_buffer = buffer_create(32,buffer_fixed,1);
myself = network_create_server_raw(network_socket_tcp,6510,20);

sendmes = "";//表示服务器要发送的数据内容，刚开始不发送的时候先清零

getmes = "";

socket_list = ds_list_create();
name_list = ds_list_create();
ip_list = ds_list_create();

alarm_set(0,20);