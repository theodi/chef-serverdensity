#
# Cookbook Name:: serverdensity
# Recipe:: default

return unless node.serverdensity.enabled

case node[:platform]

  when 'debian', 'ubuntu'
    include_recipe 'apt'

    apt_repository 'serverdensity' do
      key 'https://www.serverdensity.com/downloads/boxedice-public.key'
      uri 'https://www.serverdensity.com/downloads/linux/deb'
      distribution 'all'
      components ['main']
      action :add
    end

    dpkg_autostart 'sd-agent' do
      allow false
    end

  when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
    include_recipe 'yum::epel'

    yum_key 'RPM-GPG-KEY-serverdensity' do
      url 'https://www.serverdensity.com/downloads/boxedice-public.key'
      action :add
    end

    yum_repository 'serverdensity' do
      name 'serverdensity'
      description 'Server Density sd-agent'
      url 'https://www.serverdensity.com/downloads/linux/redhat/'
      key 'RPM-GPG-KEY-serverdensity'
      enabled 1
      action :add
    end

end

package 'sd-agent'

file '/etc/sd-agent/config.cfg' do
  action :delete
end

directory '/etc/sd-agent/conf.d'
