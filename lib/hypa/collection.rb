class Hypa::Collection
  include Virtus
  include Hypa::Actions

  attribute :_resource, Hypa::Resource, writer: :private

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def resource(resource = nil)
    resource.nil? ? self._resource : self._resource = resource
  end

  def to_hash
    { resource: (self.resource ? self.resource.to_hash : nil), actions: actions.map { |a| a.to_hash } }
  end
end