require 'extlib/hash'

class Hypa::Collection
  include Virtus
  include Hypa::Actions

  attribute :name, Symbol
  attribute :href, String
  attribute :_resource, Hypa::Resource, writer: :private

  def initialize(attributes = {}, &block)
    super(attributes)
    (block.arity == 1 ? yield(self) : instance_eval(&block)) if block_given?
  end

  def resource(resource = nil)
    resource.nil? ? self._resource : self._resource = resource
  end

  def to_hash
    { name: self.name, href: self.href, actions: actions.map { |v,a| a.to_hash } }.merge(self.resource ? self.resource.to_hash.only(:resources) : {})
  end

  # def render(action)
  #   data = self.resource.model.all
  #   self.actions[action].responses[200].render(data.map(&:values))
  # end
end