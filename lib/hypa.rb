# encoding: utf-8
require 'active_support/core_ext/class/attribute'
require 'active_model/array_serializer'
require 'active_model/serializer'

module Hypa
  module Actions    
    def self.included(base)
      base.class_attribute :_actions
      base._actions = []
      base.send :extend, ClassMethods
    end

    module ClassMethods
      ALLOWED_ACTIONS = [:get, :delete]

      def actions(*actions)
        self._actions = actions
      end

      def action(name, params = {})
        ALLOWED_ACTIONS.include?(name) && self._actions.include?(name) ? method(name).call(params) : raise(NoActionError)
      end

      # def options(env)
      #   env.response.headers['Allow'] = self._actions.map { |a| a.to_s.upcase }.join(',')
      # end
    end

    class NoActionError < Exception
    end
  end

  class Resource < ActiveModel::Serializer
    include Hypa::Actions

    class << self
      def resource_name
        name.sub(/Resource$/, '')
      end

      def model_class
        resource_name.constantize
      end

      def get(params = {})
        ActiveModel::ArraySerializer.new([model_class.find(params[:id])], root: resource_name.pluralize.underscore, each_serializer: self).to_json
      end

      def delete(params = {})
        model_class.find(params[:id]).destroy
      end
    end
  end

  class Collection
    include Hypa::Actions

    class << self
      def collection_name
        name.sub(/Collection$/, '')
      end

      def resource_class
        "#{collection_name.singularize}Resource".constantize
      end

      def query
        resource_class.model_class.all
      end

      def get(params = {})
        ActiveModel::ArraySerializer.new(query, root: collection_name.underscore, each_serializer: resource_class).to_json
      end
    end
  end
end