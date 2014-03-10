#
# Cookbook Name:: serverdensity
# Library:: alert

module ServerDensity
  class Alert

    class << self
      def create(device, meta)
        alert = API.create_alert(device, meta)
        alert.extend Base
      end

      def find(device)
        alerts = API.find_alerts(device) || []
        alerts.map { |a| a.extend Base }
      end
    end

    module Base

      def group
        self['group']
      end

      def id
        self['_id']
      end

      def delete
        API.delete_alert(self)
      end

    end

  end
end
