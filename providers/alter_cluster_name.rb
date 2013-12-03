def load_current_resource
  require "cassandra-cql"
  super
end

action :run do
  ruby "alter_cluster_name #{new_resource.name}" do
    user "root"

    conf = YAML.load_file('/etc/cassandra/conf/cassandra.yaml')

    listen_address = conf['listen_address'] || node['ipaddress']
    listen_port = conf['rpc_port'] || "9160"

    listen_address = '127.0.0.1' if listen_address == 'localhost'

    cluster_name = new_resource.name.chars.map {|c| c.unpack('H*')}.join

    code <<-RUBY
    require "cassandra-cql"
    db = CassandraCQL::Database.new("#{listen_address}:#{listen_port}", { :keyspace => "system" })
    db.execute("UPDATE local SET 'cluster_name' = '#{cluster_name}' where key = 'local'")
    RUBY

#    only_if do
#      db = CassandraCQL::Database.new("#{listen_address}:#{listen_port}", { :keyspace => "system" })
#      colfam = "local"
#      name = db.execute("SELECT * FROM #{colfam} WHERE KEY = 'local'").fetch["cluster_name"]
#      name != node["cassandra"]["cluster_name"]
#    end

    notifies :run, "script[flush #{new_resource.name}]", :immediate
  end

  #log "Flushing 

  script "flush #{new_resource.name}" do
    interpreter "bash"
    user "root"
    code "nodetool flush"
    action :nothing
  end
end

action :nothing do
end
