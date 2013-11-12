module Chef::Recipe::ServerDensity
  module API
    class V1 < Base

      def init(user, pass)
        @user = user
        @pass = pass
        params :account => account
      end

      def base_url
        @base_url ||= "#{super}/#{version}".sub '://', "://#{URI::escape(@user)}:#{URI::escape(@pass)}@"
      end

      def create(group)
        res = post '/devices/add', {
          :group => group,
          :hostName => node.hostname,
          :name => node.name,
          :notes => 'Created automatically by chef-serverdensity'
        }

        if res.code != 200
          Chef::Log.warn("Unable to create device on Serverdensity")
          return nil
        end

        res.body['data']
      end

      def find(filter)
        res = get '/devices/getByHostName', :params => filter
        Chef::Log.warn 'get'
        Chef::Log.warn res.body

        if res.code != 200
          Chef::Log.warn("Unable to retrieve device from Serverdensity")
          return nil
        end

        res.body['data']['device']
      end

      def update(device, meta)
        nil
      end
      
    end
  end
end
