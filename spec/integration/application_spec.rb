require 'spec_helper'
require 'rack/test'

require 'sequel'

DB = Sequel.sqlite

DB.create_table :posts do
  primary_key :id
  String :title
end

DB.from(:posts).insert(title: 'HypaMedia')

class Post < Sequel::Model
end

class IntegrationApp < Hypa::Application
end

IntegrationApp.resource :post, '/posts/:id' do
  properties :id, :title
  model Post
end

IntegrationApp.collection :posts, '/posts' do |c|
  c.resource IntegrationApp.resources[:post]

  c.get :self do |a|
    a.response 200, Hypa::CollectionTemplate.new(c)
  end
end

describe Hypa::Application do
  include Rack::Test::Methods

  def app
    IntegrationApp
  end

  context 'OPTIONS /posts' do
    before do
      options '/posts'
    end

    it 'returns JSON' do
      expect(last_response.headers['Content-Type']).to eq('application/json;charset=utf-8')
    end

    it 'returns the collection serialization' do
      body = JSON.load(last_response.body)
      expect(body).to eq({"name"=>"posts", "href"=>"/posts", "actions" => [{"name"=>"self", "method"=>"GET", "params"=>[], "responses"=>[{"status"=>200, "template"=>{"type"=>"array", "items"=>{"properties"=>["id", "title"]}}}]}], "resources" => {"post"=>{"properties"=>["id", "title"]}} })
    end
  end

  context 'GET /posts' do
    before do
      get '/posts'
    end

    it 'returns JSON' do
      expect(last_response.headers['Content-Type']).to eq('application/json;charset=utf-8')
    end

    it 'returns the collection of posts' do
      body = JSON.load(last_response.body)
      expect(body).to eq({ "posts" => [{ "id" => 1, "title" => "HypaMedia" }]})
    end
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
      expect(body).to eq({"name"=>"post", "href"=>"/posts/:id", "resources"=>{"post"=>{"properties"=>["id","title"]}}, "actions"=>[]})
    end
  end
end