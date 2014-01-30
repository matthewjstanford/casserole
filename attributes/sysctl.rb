# Recommended Cassandra Settings
default['sysctl']['params']['fs']['file-max']                       = 1048576
default['sysctl']['params']['net']['core']['rmem_max']              = 16777216
default['sysctl']['params']['net']['core']['wmem_max']              = 16777216
default['sysctl']['params']['net']['core']['somaxconn']             = 4096
default['sysctl']['params']['net']['ipv4']['tcp_rmem']              = [4096, 65536, 16777216]
default['sysctl']['params']['net']['ipv4']['tcp_wmem']              = [4096, 65536, 16777216]
default['sysctl']['params']['net']['ipv4']['tcp_dsack']             = 0
default['sysctl']['params']['net']['ipv4']['tcp_fack']              = 0
default['sysctl']['params']['net']['ipv4']['tcp_sack']              = 0
default['sysctl']['params']['net']['ipv4']['tcp_fin_timeout']       = 15
default['sysctl']['params']['net']['ipv4']['tcp_keepalive_intvl']   = 30
default['sysctl']['params']['net']['ipv4']['tcp_keepalive_probes']  = 9
default['sysctl']['params']['net']['ipv4']['tcp_keepalive_time']    = 300

default['sysctl']['params']['vm']['swappiness']                     = 0
default['sysctl']['params']['vm']['max_map_count']                  = 131072
default['sysctl']['params']['vm']['min_free_kbytes']                = 65536               # Keep 64 MB free on the system
default['sysctl']['params']['net']['ipv4']['tcp_window_scaling']    = 1                   # should be enabled by default
default['sysctl']['params']['net']['ipv4']['tcp_max_syn_backlog']   = 2048

