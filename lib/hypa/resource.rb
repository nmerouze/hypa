class Hypa::Resource
  include Virtus
  include Hypa::Actions

  attribute :name, Symbol
  attribute :href, String
  attribute :_properties, Array, writer: :private, default: []

  def initialize(attributes = {}, &block)
    super(attributes)
    (block.arity == 1 ? yield(self) : instance_eval(&block)) if block_given?
  end

  def properties(*properties)
    properties.empty? ? self._properties : self._properties = properties
  end

  def model(model = nil)
    model.nil? ? @model : @model = model
  end

  def to_hash
    { name: self.name, href: self.href, resources: { self.name => { properties: self.properties } }, actions: actions.map { |a| a.to_hash } }
  end
end