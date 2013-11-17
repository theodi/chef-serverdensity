#
# Cookbook Name:: serverdensity
# Resource:: default

actions :clear, :configure, :disable, :enable, :setup, :sync, :update
default_action :update

# device name
attribute :name,
  :kind_of => String,
  :name_attribute => true,
  :required => true

# apiv1 credentials
attribute :account,
  :kind_of => String,
  :name_attribute => true,
  :default => node.serverdensity.sd_url.sub(/^https?:\/\//, "")
attribute :username,
  :kind_of => String,
  :default => node.serverdensity.username
attribute :password,
  :kind_of => String,
  :default => node.serverdensity.password

# apiv2 token
attribute :token,
  :kind_of => String,
  :default => node.serverdensity.token

# optional agent_key (nil forces refresh)
attribute :agent_key,
  :kind_of => [String, NilClass],
  :regex => /^\w{32}$/,
  :default => node.serverdensity.agent_key

# optional device identifier (defaults to device name)
attribute :device,
  :kind_of => [Hash, String]

# optional metadata
attribute :metadata,
  :kind_of => Hash,
  :default => {}

# optional settings
attribute :settings,
  :kind_of => Hash,
  :default => {}
