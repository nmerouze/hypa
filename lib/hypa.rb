# encoding: utf-8
require 'active_model/array_serializer'
require 'active_model/serializer'
require 'hana'

module Hypa
  module Actions    
    def self.included(base)
      base.class_attribute :_actions
      base._actions = []
      base.extend ClassMethods
    end

    module ClassMethods
      ALLOWED_ACTIONS = [:get, :post, :patch, :delete, :options]

      def actions(*actions)
        self._actions = actions
      end

      def action(name)
        if ALLOWED_ACTIONS.include?(name) && self._actions.include?(name)
          this = self
          Proc.new { this.new(name).call(env, params) }
        else
          raise NoActionError
        end
      end
    end

    def options
      headers['Allow'] = self._actions.map { |a| a.to_s.upcase }.join(',')
      head(200)
    end

    class NoActionError < Exception
    end
  end

  # Code from: https://github.com/stripe/poncho/blob/master/lib/poncho/response.rb
  class Response < Rack::Response
    def body=(value)
      value = value.body while Rack::Response === value
      @body = String === value ? [value.to_str] : value
    end

    def each
      block_given? ? super : enum_for(:each)
    end

    def finish
      if status.to_i / 100 == 1
        headers.delete 'Content-Length'
        headers.delete 'Content-Type'
      elsif Array === body and not [204, 304].include?(status.to_i)
        # if some other code has already set Content-Length, don't muck with it
        # currently, this would be the static file-handler
        headers['Content-Length'] ||= body.inject(0) { |l, p| l + Rack::Utils.bytesize(p) }.to_s
      end

      # Rack::Response#finish sometimes returns self as response body. We don't want that.
      status, headers, result = super
      result = body if result == self
      [status, headers, result]
    end
  end

  class Request < Rack::Request
  end

  module Middleware
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      attr_reader :request, :response
    end

    def call(env, params = {})
      @env = env
      @request = Request.new(env)
      @response = Response.new

      @request.params.merge!(params.symbolize_keys)

      @response.headers['Content-Type'] = 'application/vnd.api+json'

      self.method(@object).call
    end

    def head(status)
      @response.status = status
      @response.finish
    end

    def headers
      @response.headers
    end

    def render(content, options = {})
      @response.status = options[:status] if options[:status]
      @response.body = content
      @response.finish
    end

    def params
      @request.params
    end
  end

  class Resource < ActiveModel::Serializer
    include Hypa::Actions
    include Hypa::Middleware

    def initialize(object = nil, options = {})
      super(object, options)
    end

    class << self
      def resource_name
        name.sub(/Resource$/, '')
      end

      def model_class
        resource_name.constantize
      end
    end

    def get
      serialize(resource)
    end

    def patch
      patch = Hana::Patch.new JSON.parse(@request.params['input'])
      resource.update_attributes(patch.apply({}))
      serialize(resource)
    end

    def delete
      resource.destroy
      head(204)
    end

    private

    def resource
      @resource ||= self.class.model_class.find(params[:id])
    end

    def serialize(resource)
      render ActiveModel::ArraySerializer.new([resource], root: self.class.resource_name.pluralize.underscore, each_serializer: self.class).to_json
    end
  end

  class Collection
    include Hypa::Actions
    include Hypa::Middleware

    class << self
      def collection_name
        name.sub(/Collection$/, '')
      end

      def resource_class
        "#{collection_name.singularize}Resource".constantize
      end
    end

    def initialize(object)
      @object = object
    end

    def query
      self.class.resource_class.model_class.all
    end

    def get
      serialize(query)
    end

    def post
      post = self.class.resource_class.model_class.create(params)
      headers['Location'] = "/#{self.class.collection_name.underscore}/#{post.id}"
      serialize([post], status: 201)
    end

    private

    def serialize(data, options = {})
      render ActiveModel::ArraySerializer.new(data, root: self.class.collection_name.underscore, each_serializer: self.class.resource_class).to_json, options
    end
  end
end