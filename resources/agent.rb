#
# Cookbook Name:: serverdensity
# Resource:: agent

actions :configure
default_action :configure

# device name
attribute :name,
  :kind_of => String,
  :name_attribute => true,
  :required => true

# optional agent_key (nil forces refresh)
attribute :agent_key,
  :kind_of => [String, NilClass],
  :regex => /^\w{32}$/,
  :default => node.serverdensity.agent_key

# optional device identifier (defaults to device name)
attribute :device,
  :kind_of => Hash

# optional metadata
attribute :metadata,
  :kind_of => Hash,
  :default => {}
