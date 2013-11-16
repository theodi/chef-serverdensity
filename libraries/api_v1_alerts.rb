#
# Cookbook Name:: serverdensity
# Library:: api-v1-alerts

module ServerDensity
  module API
    module V1
      module Alerts

        def convert_alert(data)
        end

        def create_alert(meta)
          res = post '/alerts/add', validate(meta)

          if res.code != 200
            Chef::Log.warn("Unable to create alert on Serverdensity")
            return nil
          end

          convert_alert res.body['data']
        end

        def find_alerts(device)
          res = get '/alerts/list', :params => {:deviceId => device.id}

          if res.code != 200
            Chef::Log.warn("Unable to retrieve alerts from Serverdensity")
            return nil
          end

          convert_alerts res.body['data']['alerts']
        end

        def delete_alert(alert)
          res = post '/alerts/delete', :params => {:alertId => alert.id}

          if res.code != 200
            Chef::Log.warn("Unable to delete alert from Serverdensity")
            return nil
          end

          true
        end

      end
    end
  end
end
