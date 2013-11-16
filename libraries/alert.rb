#
# Cookbook Name:: serverdensity
# Library:: alert

module ServerDensity
  class Alert

    class << self
      @@cache = {}

      def create(meta)
        @@cache[name] ||= begin
          alert = API.create_alert(meta)
          alert.extend Base
        end
      end

      def find(device)
        @@cache[device] ||= begin
          alerts = API.find_alerts(device)
          alerts.map { |a| a.extend Base }
        end
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
