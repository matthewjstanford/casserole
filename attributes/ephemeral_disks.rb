# ephemeral disk commands
default["cassandra"]["ephemeral_disks"]["format_command"]   = 'echo y | mkfs.ext4'
default["cassandra"]["ephemeral_disks"]["fs_check_command"] = 'dumpe2fs'
default["cassandra"]["ephemeral_disks"]["mount_options"]    = 'noatime,data=writeback,nobh'
default["cassandra"]["ephemeral_disks"]["mount_path"]       = {'/dev/sdc' => '/var/lib/cassandra',
                                                               '/dev/sdd' => '/var/lib/cassandra_d',
                                                               '/dev/sde' => '/var/lib/cassandra_e',
                                                               '/dev/sdf' => '/var/lib/cassandra_f'}
default["cassandra"]["ephemeral_disks"]["manual_disks"]     = {}

