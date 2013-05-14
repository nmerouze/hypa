require 'spec_helper'

describe Hypa::Resource do
  let(:resource) { described_class.new }
  subject { resource }

  it 'stores properties' do
    expect(resource.properties).to eq([])
    resource.properties(:id, :title)
    expect(resource.properties).to eq([:id, :title])
  end

  it_has_behavior 'defining actions'

  describe '#to_hash' do
    it 'serializes the object' do
      resource.properties(:id, :title)
      expect(resource.to_hash).to eq({ properties: [:id, :title], actions: [] })
    end
  end
end