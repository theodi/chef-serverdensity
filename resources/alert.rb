#
# Cookbook Name:: serverdensity
# Resource:: alert

actions :add, :remove
default_action :add

# alert name
attribute :name,
  :kind_of => String,
  :name_attribute => true,
  :required => true

# optional device identifier (defaults to current device)
attribute :device,
  :kind_of => [Hash, String]

# optional metadata
attribute :metadata,
  :kind_of => Hash,
  :default => {}
