require 'spec_helper'

describe 'A resource' do
  let :resource do
    Hypa::Resource.new do
      properties :id, :title

      get :self do
        params :id
        response 200, Hypa::Template.new
      end
    end
  end

  let(:template) { Hypa::Template.new }
  let(:action) { resource.actions[:self] }
  let(:response) { action.responses[200] }

  before do
    Hypa::Template.stub(:new).and_return(template)
  end

  it 'defines an action' do
    expect(resource.actions.size).to eq(1)

    expect(action.name).to eq(:self)
    expect(action.method).to eq('GET')
    expect(action.params).to eq([:id])
    expect(action.responses.size).to eq(1)

    expect(response.status).to eq(200)
    expect(response.template).to eq(template)
  end
end