# create the alerts defined in the ['serverdensity']['alerts'] hash

include_recipe "serverdensity"

serverdensity node.name

node.serverdensity.alerts.each do | name, alert |
  Chef::Log.info "Creating Server Density alert name:#{name}"
  lxc_container name do
    container.each do |meth, param|
      self.send(meth, param)
    end
    action :create unless alert.has_key?(:action)
  end
end
