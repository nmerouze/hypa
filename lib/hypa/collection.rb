class Hypa::Collection
  include Virtus
  include Hypa::Actions

  attribute :_resource, Hypa::Resource, writer: :private

  def initialize(attributes = {}, &block)
    super(attributes)
    (block.arity == 1 ? yield(self) : instance_eval(&block)) if block_given?
  end

  def resource(resource = nil)
    resource.nil? ? self._resource : self._resource = resource
  end

  def to_hash
    { actions: actions.map { |a| a.to_hash } }.merge((self.resource ? self.resource.to_hash : {}))
  end
end