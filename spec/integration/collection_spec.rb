require 'spec_helper'

PostResource = Hypa::Resource.new do
  properties :id, :title
end

describe 'A collection' do
  let(:resource) { PostResource }

  let :collection do
    Hypa::Collection.new do
      resource PostResource

      get :self do
        params :title_in
        response 200, Hypa::Template.new
      end
    end
  end

  let(:template) { Hypa::Template.new }
  let(:action) { collection.actions.first }
  let(:response) { action.responses[200] }

  before do
    Hypa::Template.stub(:new).and_return(template)
  end

  it 'defines an action' do
    expect(collection.actions.size).to eq(1)

    expect(action.name).to eq(:self)
    expect(action.method).to eq('GET')
    expect(action.params).to eq([:title_in])
    expect(action.responses.size).to eq(1)

    expect(response.status).to eq(200)
    expect(response.template).to eq(template)
  end

  it 'defines a resource' do
    expect(collection.resource).to eq(resource)
  end
end