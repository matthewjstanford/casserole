actions :run, :nothing
default_action :run

attribute :listen_ip,   :kind_of => String,         :default => nil
attribute :port,        :kind_of => String,         :default => "9160"
attribute :name,        :kind_of => String,         :name_attribute => true

def load_current_resource
  super
  @current_resource.name = @new_resource.name
  @current_resource.port = @new_resource.port
  @current_resource.listen_ip = @new_resource.listen_ip
end
