#
# Cookbook Name:: serverdensity
# Library:: api-v1

module ServerDensity
  module API

    module V1
      include Base

      def base_url
        @base_url ||= "https://api.serverdensity.com/#{version}"
          .sub '://', "://#{URI::escape(@user)}:#{URI::escape(@pass)}@"
      end

      def convert(data)
        out = data.dup

        if data.has_key? 'device'
          out.delete 'device'
          out['_id'] = data['device']['deviceId']
        else
          out.delete 'deviceId'
          out['_id'] = data['deviceId']
        end

        out.delete 'hostName'
        out.merge({
          'hostname' => data['hostName']
        })
      end

      def create_device(meta)
        res = post '/devices/add', validate(meta,
          :notes => 'Created automatically by chef-serverdensity'
        )

        if res.code != 200
          Chef::Log.warn("Unable to create device on Serverdensity")
          return nil
        end

        convert res.body['data']
      end

      def find_device(meta)
        endpoint = case meta.first.first
          when :name then '/devices/getByName'
          when :hostname, :hostName then '/devices/getByHostName'
          else
            Chef::Log.warn("Server Density v1 only supports searching using name or hostname")
            return nil
        end

        res = get endpoint, :params => validate(meta)

        if res.code != 200
          Chef::Log.warn("Unable to retrieve device from Serverdensity")
          return nil
        end

        convert res.body['data']['device']
      end

      def update_device(device, meta)
        Hash.new
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
