#
# Cookbook Name:: serverdensity
# Library:: device

module ServerDensity
  class Device

    class << self
      @@cache = {}

      def create(meta)
        @@cache[meta] ||= begin
          device = API.create_device(meta)
          device.extend Base
        end
      end

      def find(meta)
        @@cache[meta] ||= begin
          meta = {:name => meta} if meta.class == String
          device = API.find_device(meta)
          device.extend Base
        end
      end
    end

    module Base

      def agent_key
        self['agentKey']
      end

      def group
        self['group']
      end

      def hostname
        self['hostname']
      end

      def name
        self['name']
      end

      def id
        self['_id']
      end

      def update(meta)
        self.merge! API.update_device(self, meta)
      end

    end

  end
end
