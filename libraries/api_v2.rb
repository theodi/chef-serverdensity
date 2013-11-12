module Chef::Recipe::ServerDensity
  module API
    class V2 < Base

      def init(token)
        params :token => token
      end

      def create(group)
        res = post '/inventory/devices', {
          group: group,
          hostname: node.hostname,
          name: node.name
        }
        Chef::Log.warn 'post'
        Chef::Log.warn res.body

        if res.code != 200
          Chef::Log.warn("Unable to create device on Serverdensity")
          return nil
        end

        res.body
      end

      def find(filter)
        res = get '/inventory/resources', :params => {
          filter: Chef::JSONCompat.to_json(filter),
          type: 'device'
        }
        Chef::Log.warn 'get'
        Chef::Log.warn res.body

        if res.code != 200 or res.body.empty?
          Chef::Log.warn("Unable to retrieve device from Serverdensity")
          return nil
        end

        res.body.first
      end

      def update(device, meta)
        meta.reject! { |k, v| device[k] == v }
        return device if meta.empty?

        res = put "/inventory/devices/#{device['_id']}", meta
        Chef::Log.warn 'put'
        Chef::Log.warn res.body

        if res.code != 200
          Chef::Log.warn("Unable to update device on Serverdensity")
          return nil
        end

        res.body
      end

    end
  end
end
