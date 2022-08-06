server_list = ds_list_create();
server_names = ds_list_create();
broadcast_server = network_create_server_raw(network_socket_udp,6511,20);