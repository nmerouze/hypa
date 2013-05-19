require 'spec_helper'

Constant = Class.new

describe Hypa::Resource do
  let(:resource) { described_class.new }
  subject { resource }

  it 'stores a name' do
    expect(resource.name).to be_nil
    resource.name = :post
    expect(resource.name).to eq(:post)
  end

  it 'stores a href' do
    expect(resource.href).to be_nil
    resource.href = '/posts/:id'
    expect(resource.href).to eq('/posts/:id')
  end

  it 'stores a model' do
    expect(resource.model).to be_nil
    resource.model Constant
    expect(resource.model).to eq(Constant)
  end

  it 'stores properties' do
    expect(resource.properties).to eq([])
    resource.properties(:id, :title)
    expect(resource.properties).to eq([:id, :title])
  end

  it_has_behavior 'defining actions'

  describe '#to_hash' do
    it 'serializes the object' do
      resource.name = :post
      resource.href = '/posts/{id}'
      resource.properties(:id, :title)
      expect(resource.to_hash).to eq({
        name: :post,
        href: '/posts/{id}',
        resources: { post: { properties: [:id, :title] } },
        actions: []
      })
    end
  end
end