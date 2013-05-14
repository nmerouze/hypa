class Hypa::Template
  def to_hash
    {}
  end
end

class Hypa::ResourceTemplate < Hypa::Template
  def initialize(resource)
    @resource = resource
  end

  def to_hash
    { type: 'array', items: { properties: @resource.properties } }
  end
end

class Hypa::CollectionTemplate < Hypa::Template
  def initialize(collection)
    @collection = collection
  end

  def to_hash
    { type: 'array', items: { properties: @collection.resource.properties } }
  end
end