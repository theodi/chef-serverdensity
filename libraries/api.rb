#
# Cookbook Name:: serverdensity
# Library:: api

module ServerDensity
  module API

    class << self
      def configure(version, *args)
        def configure(*args)
          Chef::Log.warn("Server Density API has already been configured")
          self
        end
        case version.to_i
          when 1 then class << self; include V1; end
          when 2 then class << self; include V2; end
          else raise 'Invalid Server Density API version'
        end
        @version = version
        initialize(*args)
        self
      end

      def configured?
        not @version.nil?
      end
    end

  end
end
