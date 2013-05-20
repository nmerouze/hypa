require 'spec_helper'

describe Hypa::ResourceTemplate do
  before do
    resource = double('Hypa::Resource', properties: [:id, :title])
    @template = Hypa::ResourceTemplate.new(resource)
  end

  it 'serializes the template based on the resource' do
    expect(@template.to_hash).to eq({
      type: 'array',
      items: { properties: [:id, :title] }
    })
  end
end

describe Hypa::CollectionTemplate do
  before do
    resource = double('Hypa::Resource', properties: [:id, :title])
    collection = double('Hypa::Collection', resource: resource)
    @template = Hypa::CollectionTemplate.new(collection)
  end

  it 'serializes the template based on the resource' do
    expect(@template.to_hash).to eq({
      type: 'array',
      items: { properties: [:id, :title] }
    })
  end

  describe '#render' do
    it 'renders the template' do
      result = @template.render([{ id: 1, title: 'Foobar', not_in_resource: 'Test' }])
      expect(result).to eq([{ id: 1, title: 'Foobar' }])
    end
  end
end