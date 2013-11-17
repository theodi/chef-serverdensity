#
# Cookbook Name:: serverdensity
# Library:: api-v1-alerts

module ServerDensity
  module API
    module V1
      module Alerts

        def create_alert(device, meta)
          convert_alert post('/alerts/add', validate(meta, :serverId => device['_serverId'])).body['data']
        rescue => err
          error(err, 'Unable to create alert on Serverdensity')
        end

        def find_alerts(device)
          get('/alerts/list', :params => {:deviceId => device.id}).body['data']['alerts'].map do |a|
            convert_alert a
          end
        rescue => err
          error(err, 'Unable to retrieve alerts from Serverdensity')
        end

        def delete_alert(alert)
          post('/alerts/delete', :alertId => alert.id); true
        rescue => err
          error(err, 'Unable to delete alert from Serverdensity')
        end

        private

        def convert_alert(data)
          out = data.dup

          if data.has_key? 'alert'
            out['_id'] = data['alert']['alertId']
          else
            out.delete 'alertId'
            out['_id'] = data['alertId']
          end

          out['group'] = nil

          out
        end

      end
    end
  end
end
