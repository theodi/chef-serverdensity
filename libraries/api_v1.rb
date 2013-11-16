#
# Cookbook Name:: serverdensity
# Library:: api-v1

module ServerDensity
  module API

    module V1
      include Base
      include Alerts
      include Devices

      def base_url
        @base_url ||= "https://#{@user}:#{@pass}@api.serverdensity.com/#{version}"
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
