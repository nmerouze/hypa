require 'spec_helper'

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

    expect(action.responses).to eq({})
    action.response(200, Hypa::Template.new)
    expect(action.responses).to eq({ 200 => response })
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