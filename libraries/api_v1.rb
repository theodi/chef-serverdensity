module ServerDensity
  module API

    module V1
      include Base

      def base_url
        @base_url ||= "https://api.serverdensity.com/#{version}"
          .sub '://', "://#{URI::escape(@user)}:#{URI::escape(@pass)}@"
      end

      def create_device(meta)
        res = post '/devices/add', validate(meta,
          :notes => 'Created automatically by chef-serverdensity'
        )

        if res.code != 200
#           Chef::Log.warn("Unable to create device on Serverdensity")
          return nil
        end

        res.body['data']
      end

      def find_device(meta)
        res = get '/devices/getByHostName', :params => validate(meta)
#         Chef::Log.warn 'get'
#         Chef::Log.warn res.body

        if res.code != 200
#           Chef::Log.warn("Unable to retrieve device from Serverdensity")
          return nil
        end

        res.body['data']['device']
      end

      def update_device(device, meta)
        nil
      end

      def validate(meta, default = {})
        meta = super
        meta[:hostName] = meta.delete(:hostname) if meta.has_key? :hostname
        meta
      end

      private

      def initialize(account, user, pass)
        @user = user
        @pass = pass
        params :account => account
      end
    end

  end
end
