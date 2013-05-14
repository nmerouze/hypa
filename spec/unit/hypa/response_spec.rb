require 'spec_helper'

describe Hypa::Response do
  let(:response) { described_class.new }

  it 'stores a status' do
    expect(response.status).to be_nil
    response.status = 200
    expect(response.status).to eq(200)
  end

  it 'stores a template' do
    template = Hypa::Template.new
    expect(response.template).to be_nil
    response.template = template
    expect(response.template).to eq(template)
  end

  describe '#to_hash' do
    it 'serializes the object' do
      response.status = 200
      expect(response.to_hash).to eq({ status: 200, template: nil })
    end
  end
end