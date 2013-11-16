#
# Cookbook Name:: serverdensity
# Library:: api-base

module ServerDensity
  module API

    module Base
      attr_reader :version

      def _request(method, path, payload, options = {}, &block)
        options[:params] = if options.has_key? :params
          params.merge(options[:params])
        else
          params
        end

        req = { method: method, url: "#{base_url}#{path}", headers: options }
        req[:payload] = payload if [:patch, :post, :put].include? method

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

      def base_url
        nil
      end

      def params(value = nil)
        @params ||= {}
        if value.nil?
          @params
        else
          @params.merge! value
        end
      end

      def validate(meta, default = {})
        meta.each do |k, v|
          default.update(k.to_sym => v)
        end unless meta.nil?
        default
      end
    end

  end
end
