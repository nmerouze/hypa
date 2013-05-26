# encoding: utf-8
require 'active_support/core_ext/class/attribute'
require 'active_model/array_serializer'
require 'active_model/serializer'

module Hypa
  class Resource < ActiveModel::Serializer
    def self.model_class
      name.sub(/Resource$/, '').constantize
    end
  end

  class Collection
    class_attribute :_actions
    # class_inheritable_accessor :links
    # self.links = {}
    ALLOWED_ACTIONS = [:get, :options]

    class << self
      def collection_name
        name.sub(/Collection$/, '')
      end

      def resource_class
        "#{collection_name.singularize}Resource".constantize
      end

      def actions(*actions)
        self._actions = actions
      end

      def action(name)
        ALLOWED_ACTIONS.include?(name) ? method(name).call : NoActionError
      end

      def query
        resource_class.model_class.all
      end

      def get
        ActiveModel::ArraySerializer.new(query, root: collection_name.underscore, each_serializer: resource_class).to_json
      end

      def options
        resource_class.schema.to_json
      end
    end

    class NoActionError < Exception
    end
  end
end