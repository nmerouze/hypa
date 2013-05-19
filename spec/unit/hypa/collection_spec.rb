require 'spec_helper'

describe Hypa::Collection do
  let(:collection) { described_class.new(name: :posts, href: '/posts') }
  subject { collection }

  it 'stores resource' do
    resource = Hypa::Resource.new
    expect(collection.resource).to be_nil
    collection.resource(resource)
    expect(collection.resource).to eq(resource)
  end

  it_has_behavior 'defining actions'

  describe '#to_hash' do
    it 'serializes the object' do
      expect(collection.to_hash).to eq({ name: :posts, href: '/posts', actions: [] })
    end
  end
end