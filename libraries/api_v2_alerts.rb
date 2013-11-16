#
# Cookbook Name:: serverdensity
# Library:: api-v2-alerts

module ServerDensity
  module API
    module V2
      module Alerts

        def create_alert(meta)
          res = post '/alerts/configs', validate(meta)

          if res.code != 200
            Chef::Log.warn("Unable to create alert on Serverdensity")
            return nil
          end

          res.body
        end

        def find_alerts(resource)
          res = get "/alert/configs/#{resource.id}", :params => {
            :subjectType => resource.class.to_s.downcase
          }
          
          if res.code != 200
            Chef::Log.warn("Unable to find alerts on Serverdensity")
            return nil
          end

          res.body
        end

        def delete_alert(alert)
          res = delete "/alerts/configs/#{alert.id}"

          if res.code != 200
            Chef::Log.warn("Unable to delete alert on Serverdensity")
            return nil
          end

          true
        end

      end
    end
  end
end
