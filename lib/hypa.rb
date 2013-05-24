# encoding: utf-8
require 'active_support/core_ext/class/attribute'
require 'active_model/array_serializer'

module Hypa
  class Resource
    class_attribute :_actions
    # class_inheritable_accessor :links
    # self.links = {}
    # TODO: ALLOWED_ACTIONS = [:get, ...]

    class << self
      def actions(*actions)
        self._actions = actions
      end

      def action(name)
        method(name).call
      end

      def query(&block)
        @query = block
      end

      def get
        ActiveModel::ArraySerializer.new(@query.call, root: self.name.underscore.split('_').first).to_json
      end
    end
  end

  class Collection < Resource
  end
end