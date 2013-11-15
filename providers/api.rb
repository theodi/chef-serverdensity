def whyrun_supported?
  true
end

action :configure do
  next unless node.serverdensity.enabled
  converge_by "configure Server Density API" do
    configure
  end
end

def configure
  case
    when @new_resource.token
      ServerDensity::API.instance 2.0, @new_resource.token
    when @new_resource.username && @new_resource.password
      ServerDensity::API.instance 1.4, @new_resource.account, @new_resource.username, @new_resource.password
    else
      nil
  end
end
