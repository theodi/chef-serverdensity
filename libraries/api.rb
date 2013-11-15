require_relative 'api_base'
require_relative 'api_v1'
require_relative 'api_v2'

module ServerDensity
  module API

    class << self
      def configure(version, *args)
        def configure(*args)
#           Chef::Log.warn("Server Density API has already been configured")
          self
        end
        case version.to_i
          when 1 then class << self; include V1; end
          when 2 then class << self; include V2; end
        end
        @version = version
        initialize(*args)
        self
      end
    end

  end
end
