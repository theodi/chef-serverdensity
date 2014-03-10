#
# Cookbook Name:: serverdensity
# Library:: api-v1-devices

module ServerDensity
  module API
    module V1
      module Devices

        def create_device(meta)
          convert_device post('/devices/add', validate(meta,
            :notes => 'Created automatically by chef-serverdensity'
          )).body['data']
        rescue => err
          error(err, 'Unable to create device on Serverdensity')
        end

        def find_device(meta)
          meta = validate(meta)
          endpoint = case meta.first.first
            when :name then '/devices/getByName'
            when :hostName then '/devices/getByHostName'
            else
              Chef::Log.warn("Server Density v1 only supports searching using name or hostname")
              return nil
          end
          convert_device get(endpoint, :params => meta).body['data']['device']
        rescue => err
          error(err, 'Unable to retrieve device from Serverdensity')
        end

        def update_device(device, meta)
          Hash.new
        end

        private

        def convert_device(data)
          out = data.dup

          if data.has_key? 'device'
            out.delete 'device'
            out['_id'] = data['device']['deviceId']
            out['_serverId'] = data['device']['deviceIdOld']
          else
            out.delete 'deviceId'
            out['_id'] = data['deviceId']
            out['_serverId'] = data['deviceIdOld']
          end

          out.delete 'hostName'
          out.merge({
            'hostname' => data['hostName']
          })
        end

      end
    end
  end
end
