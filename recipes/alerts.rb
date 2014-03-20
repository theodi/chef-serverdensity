#
# Cookbook Name:: serverdensity
# Recipe:: alerts

include_recipe 'serverdensity'

serverdensity node.name do
  action [:update, :clear]
end

node.serverdensity.alerts.each do | name, alert |
  serverdensity_alert name do
    alert.each do |meth, param|
      self.send(meth, param)
    end
    action :create unless alert.has_key?(:action)
  end
end
