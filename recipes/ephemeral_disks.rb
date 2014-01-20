
ephemeral_disks = Mash.new

defaults = node["cassandra"]["ephemeral_disks"]

# If the current node has an ephemeral disk, we want it.
if node.has_key?('ec2')
  node['ec2'].select {|key,val| key.start_with?('block_device_mapping_ephemeral')}.each do |key,val|
    device = "/dev/#{val}"
    ephemeral_disks[device] = {
      :format_command     => defaults["format_command"],
      :fs_check_command   => defaults["fs_check_command"],
      :mount_path         => defaults["mount_path"][device],
      :mount_options      => defaults["mount_options"],
      :mount              => true,
      :format             => true
    }
  end
end

# Allow the operator to override any of the auto detected options
node["cassandra"]["ephemeral_disks"]["manual_disks"].each do |device,params|
  ephemeral_disks[device] = { :format_command   => params[:format_command]    || defaults["format_command"],
                              :fs_check_command => params[:fs_check_command]  || defaults["fs_check_command"],
                              :mount_path       => params[:mount_path]        || defaults["mount_path"][device] || "/var/lib/cassandra",
                              :mount_options    => params[:mount_options]     || defaults["mount_options"],
                              :format           => params[:format]            || true,
                              :mount            => params[:mount]             || true
                            }
end                            

# Be sure to include this new dir in the data directories config
data_file_directories = []
ephemeral_disks.select {|device,params| params[:format] && params[:mount]}.values.each do |params|
  data_file_directories << File.join(params[:mount_path],'/data/')
end

node.set['cassandra']['config']['data_file_directories'] = data_file_directories unless data_file_directories.empty?

ephemeral_disks.each do |device,params|
  # Format volume if format command is provided and volume is unformatted
  bash "Format device: #{device}" do
    __command  = "#{params[:format_command]} #{device}"
    __fs_check = params[:fs_check_command] || 'dumpe2fs'

    code __command

    only_if { params[:format_command] && params[:format] }
    not_if  "#{__fs_check} #{device}"

    # Make sure Cassandra rebuilds
    node.override["cassandra"]["nodetool_rebuild"] = true
  end

  # Create directory with proper permissions
  directory params[:mount_path] do
    owner 'root' 
    group 'root'
    mode 0755
  end

  # Mount device to data path
  mount "#{device}-to-#{params[:mount_path]}" do
    mount_point params[:mount_path]
    device  device
    fstype  params[:file_system]
    options params[:mount_options]
    action  [:mount, :enable]

    only_if { File.exists?(device) && params[:mount] }
  end

  # Make sure cassandra directories exist
  ['data','commitlog','saved_caches'].each do |dir|
    directory File.join(params[:mount_path],dir) do
      owner node["cassandra"]["user"]
      group node["cassandra"]["group"]
      mode 0755
      only_if "grep #{node["cassandra"]["user"]} /etc/passwd"
      only_if { params[:mount] }
    end
  end
end
