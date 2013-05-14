require 'spec_helper'

describe Hypa::Collection do
  let(:collection) { described_class.new }
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
      expect(collection.to_hash).to eq({ resource: nil, actions: [] })
    end
  end
end