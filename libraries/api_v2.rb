#
# Cookbook Name:: serverdensity
# Library:: api-v2

module ServerDensity
  module API
    
    module V2
      include Base
      include Alerts
      include Devices

      def base_url
        'https://api.serverdensity.io'
      end

      private

      def initialize(token)
        params :token => token
      end
    end

  end
end
