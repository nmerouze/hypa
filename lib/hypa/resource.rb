class Hypa::Resource
  include Virtus
  include Hypa::Actions

  attribute :_properties, Array, writer: :private, default: []

  def initialize(&block)
    (block.arity == 1 ? yield(self) : instance_eval(&block)) if block_given?
  end

  def properties(*properties)
    properties.empty? ? self._properties : self._properties = properties
  end

  def to_hash
    { properties: self.properties, actions: actions.map { |a| a.to_hash } }
  end
end