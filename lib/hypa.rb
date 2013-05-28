# encoding: utf-8
require 'active_model/array_serializer'
require 'active_model/serializer'

module Hypa
  module Actions    
    def self.included(base)
      base.class_attribute :_actions
      base._actions = []
      base.extend ClassMethods
    end

    module ClassMethods
      ALLOWED_ACTIONS = [:get, :post, :delete]

      def actions(*actions)
        self._actions = actions
      end

      def action(name)
        if ALLOWED_ACTIONS.include?(name) && self._actions.include?(name)
          this = self
          Proc.new { this.call(name, env, params) }
        else
          raise NoActionError
        end
      end

      # def options(env)
      #   env.response.headers['Allow'] = self._actions.map { |a| a.to_s.upcase }.join(',')
      # end
    end

    class NoActionError < Exception
    end
  end

  class Response < Rack::Response
  end

  class Request < Rack::Request
  end

  module Middleware
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      attr_reader :request, :response

      def call(action, env, params = {})
        self.new.call(action, env, params)
      end
    end

    def call(action, env, params)
      @env = env
      @request = Request.new(env)
      @response = Response.new

      @request.params.merge!(params)

      render(self.method(action).call)
    end

    def head(status)
      @response.status = status
      @response.finish
    end

    def render(content)
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
      ActiveModel::ArraySerializer.new([self.class.model_class.find(params[:id])], root: self.class.resource_name.pluralize.underscore, each_serializer: self.class).to_json
    end

    def delete
      self.class.model_class.find(params[:id]).destroy
      head(204)
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

    def query
      self.class.resource_class.model_class.all
    end

    def get
      ActiveModel::ArraySerializer.new(query, root: self.class.collection_name.underscore, each_serializer: self.class.resource_class).to_json
    end

    def post
      post = self.class.resource_class.model_class.create(params)
      ActiveModel::ArraySerializer.new([post], root: self.class.collection_name.underscore, each_serializer: self.class.resource_class).to_json
    end
  end
end