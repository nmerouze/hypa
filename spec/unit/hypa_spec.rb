require 'spec_helper'

describe Hypa::Template do
end

describe Hypa::Action do
  let(:action) { described_class.new }

  it 'stores params' do
    expect(action.params).to eq([])
    action.params(:id, :title)
    expect(action.params).to eq([:id, :title])
  end

  it 'stores a name' do
    expect(action.name).to be_nil
    action.name = :self
    expect(action.name).to eq(:self)
  end

  it 'stores a method' do
    expect(action.method).to be_nil
    action.method = 'GET'
    expect(action.method).to eq('GET')
  end

  it 'stores a response' do
    response = Hypa::Response.new(status: 200, template: Hypa::Template.new)
    Hypa::Response.stub(:new).and_return(response)

    expect(action.responses).to eq([])
    action.response(200, Hypa::Template.new)
    expect(action.responses).to eq([response])
  end

  describe '#to_hash' do
    it 'serializes the object' do
      action.name = :self
      action.method = 'GET'
      action.params(:id, :title)
      expect(action.to_hash).to eq({ name: :self, method: 'GET', params: [:id, :title], responses: [] })
    end
  end
end

# FIX: Doesn't assert action's method
shared_examples 'defining actions' do
  before do
    @action = Hypa::Action.new
    Hypa::Action.stub(:new).and_return(@action)
    expect(subject.actions).to eq([])
  end

  it 'stores a get action' do
    subject.get(:self) {}
    expect(subject.actions).to eq([@action])
  end

  it 'stores a post action' do
    subject.post(:create) {}
    expect(subject.actions).to eq([@action])
  end

  it 'stores a patch action' do
    subject.patch(:create) {}
    expect(subject.actions).to eq([@action])
  end

  it 'stores a delete action' do
    subject.delete(:create) {}
    expect(subject.actions).to eq([@action])
  end
end

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