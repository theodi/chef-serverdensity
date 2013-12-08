#
# Cookbook Name:: serverdensity
# Library:: api-v1

require_relative 'api_v1_alerts'
require_relative 'api_v1_devices'

module ServerDensity
  module API

    module V1
      include Base
      include Alerts
      include Devices

      protected

      def base_url
        @base_url ||= "https://#{@user}:#{@pass}@api.serverdensity.com/#{version}"
      end

      def error(err, message)
        message = "Server Density API error: #{err.response['error']}" rescue message
        Chef::Log.warn(message)
        nil
      end

      def validate(meta, default = {})
        meta = super
        meta[:hostName] = meta.delete(:hostname) if meta.has_key? :hostname
        meta
      end

      private

      def initialize(account, user, pass)
        @user = URI::escape(user)
        @pass = URI::escape(pass)
        params :account => account
      end
    end

  end
end
