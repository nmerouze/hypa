require 'spec_helper'
require 'rack/test'

class IntegrationApp < Hypa::Application
end

IntegrationApp.resource :post, '/posts/:id'

describe Hypa::Application do
  include Rack::Test::Methods

  def app
    IntegrationApp
  end

  context 'OPTIONS /posts/42' do
    before do
      options '/posts/42'
    end

    it 'returns JSON' do
      expect(last_response.headers['Content-Type']).to eq('application/json;charset=utf-8')
    end

    it 'returns the resource serialization' do
      body = JSON.load(last_response.body)
      expect(body).to eq({"resources"=>{"post"=>{"properties"=>[]}}, "actions"=>[]})
    end
  end
end