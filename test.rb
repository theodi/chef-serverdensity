require_relative 'libraries/api'

api = ServerDensity::API.instance 2.0, '234'

puts api.version
