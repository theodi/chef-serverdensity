#
# Cookbook Name:: serverdensity
# Resource:: alert

actions :add
default_action :add

# alert name
attribute :name,
  :kind_of => String,
  :name_attribute => true,
  :required => true

# optional device identifier (defaults to current device)
attribute :device,
  :kind_of => [Hash, String],
  :default => node.name

# optional metadata
attribute :metadata,
  :kind_of => Hash,
  :required => true
