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
default['sysctl']['params']['vm']['min_free_kbytes']                = 65536               # Keep 64 MB free on the system
default['sysctl']['params']['net']['ipv4']['tcp_window_scaling']    = 1                   # should be enabled by default
default['sysctl']['params']['net']['ipv4']['tcp_max_syn_backlog']   = 2048

# RedHat default settings:
default['sysctl']['params']['net']['bridge']['bridge-nf-call-ip6tables'] = 0              # Disable netfilter on bridges.
default['sysctl']['params']['net']['bridge']['bridge-nf-call-iptables'] = 0               # Disable netfilter on bridges.
default['sysctl']['params']['net']['bridge']['bridge-nf-call-arptables'] = 0              # Disable netfilter on bridges.
default['sysctl']['params']['net']['ipv4']['conf']['default']['accept_source_route'] = 0  # Do not accept source routing
default['sysctl']['params']['net']['ipv4']['conf']['default']['rp_filter'] = 1            # Controls source route verification
default['sysctl']['params']['net']['ipv4']['ip_forward'] = 0                              # Controls IP packet forwarding
default['sysctl']['params']['net']['ipv4']['tcp_syncookies'] = 1                          # Controls the use of TCP syncookies
default['sysctl']['params']['kernel']['core_uses_pid'] = 1                                # Controls whether core dumps will append the PID to the core filename.
default['sysctl']['params']['kernel']['msgmnb'] = 65536                                   # Controls the default maxmimum size of a mesage queue
default['sysctl']['params']['kernel']['msgmax'] = 65536                                   # Controls the maximum size of a message, in bytes
default['sysctl']['params']['kernel']['printk'] = [8, 4, 1, 7]                            # Maximize console logging level for kernel printk messages
default['sysctl']['params']['kernel']['printk_ratelimit'] = 5                             # Maximize console logging level for kernel printk messages
default['sysctl']['params']['kernel']['printk_ratelimit_burst'] = 10                      # Maximize console logging level for kernel printk messages
default['sysctl']['params']['kernel']['shmmax'] = 68719476736                             # Controls the maximum shared segment size, in bytes
default['sysctl']['params']['kernel']['shmall'] = 4294967296                              # Controls the maximum number of shared memory segments, in pages
default['sysctl']['params']['kernel']['sysrq'] = 0                                        # Controls the System Request debugging functionality of the kernel
