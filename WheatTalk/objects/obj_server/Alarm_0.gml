buffer_seek(broadcast_buffer,buffer_seek_start,0);
buffer_write(broadcast_buffer,buffer_string,"&sern=" + servername);
network_send_broadcast(myself, 6511, broadcast_buffer, buffer_tell(broadcast_buffer));
alarm_set(0,60);