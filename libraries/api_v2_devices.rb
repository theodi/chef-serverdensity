#
# Cookbook Name:: serverdensity
# Library:: api-v2-devices

module ServerDensity
  module API
    module V2
      module Devices

        def create_device(meta)
          res = post '/inventory/devices', validate(meta)

          if res.code != 200
            Chef::Log.warn("Unable to create device on Serverdensity")
            return nil
          end

          res.body
        end

        def find_device(meta)
          find('device', meta)
        end

        def update_device(device, meta)
          meta = validate(meta).reject! { |k, v| device[k.to_s] == v }
          return device if meta.empty?

          res = put "/inventory/devices/#{device['_id']}", meta

          if res.code != 200
            Chef::Log.warn("Unable to update device on Serverdensity")
            return nil
          end

          res.body
        end

        private

        def find(type, meta)
          res = get '/inventory/resources', :params => {
            filter: Chef::JSONCompat.to_json(validate(meta)),
            type: type
          }

          if res.code != 200 or res.body.empty?
            Chef::Log.warn("Unable to retrieve #{type} from Serverdensity")
            return nil
          end

          res.body.first
        end

      end
    end
  end
end
