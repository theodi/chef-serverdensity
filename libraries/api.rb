require 'singleton'

module ServerDensity
  module API

    class Base
      include Singleton

      attr_reader :version

      class << self
        def __init__(klass) # :nodoc:
          klass.instance_eval {
            @singleton__instance__ = nil
            @singleton__mutex__ = Mutex.new
          }
          def klass.instance(*args)
            @singleton__instance__ ||= @singleton__mutex__.synchronize {
              @singleton__instance__ ||= new(*args)
            }
          end
          klass
        end

        private

        def inherited(sub_klass)
          super
          self.__init__(sub_klass)
        end
      end

      def initialize(version)
        @version = version.to_f
      end

      def _request(method, path, payload, options = {}, &block)
        options[:params] = if options.has_key? :params
          params.merge(options[:params])
        else
          params
        end

        req = { method: method, url: "#{base_url}#{path}", headers: options }
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

    def self.instance(version, *args)
      @instance ||= case version.to_i
        when 1 then V1
        when 2 then V2
      end .instance version, *args
    end

  end
end

require_relative 'api_v1'
require_relative 'api_v2'
