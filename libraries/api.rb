module Chef::Recipe::ServerDensity
  module API

    ACCOUNT

    class Base
      attr_reader :node
      attr_reader :version

      def initialize(ctx, version, *args)
        @node = ctx.node
        @version = version.to_f
        init(*args)
      end

      def _request(method, path, payload, options = {}, &block)
        options[:params] = if options.has_key? :params
          params.merge(options[:params])
        else
          params
        end

        req = {
          method: method,
          url: "#{base_url}#{path}",
          headers: options
        }
        req[:payload] = payload if [:patch, :post, :put].include? method

        Chef::Log.warn req.inspect

        begin
          res = RestClient::Request.execute req, &block
        rescue => err
          res = err.response
        end

        RestClient::Response.create(
          Chef::JSONCompat.from_json(res),
          res.net_http_res,
          res.args
        )
      end

      def get(path, *args, &block)
        _request :get, path, nil, *args, &block
      end

      def post(path, *args, &block)
        _request :post, path, *args, &block
      end

      def put(path, *args, &block)
        _request :put, path, *args, &block
      end

      def account
        node.serverdensity.sd_url.sub /^https?:\/\//, ""
      end

      def base_url
        @base_url ||= begin
          node.serverdensity.api_url[version].chomp '/'
        rescue
          node.serverdensity.api_url[version.to_i].chomp '/'
        end
      end

      def params(value = nil)
        @params ||= {}
        if value.nil?
          @params
        else
          @params.merge! value
        end
      end
    end

    def self.new(ctx, version, *args)
      case version.to_i
        when 1 then V1
        when 2 then V2
      end .new ctx, version, *args
    end

  end
end
