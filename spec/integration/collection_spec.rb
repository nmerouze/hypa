require 'spec_helper'
require 'sequel'

DB = Sequel.sqlite

DB.create_table :posts do
  primary_key :id
  String :title
end

DB.from(:posts).insert(title: 'HypaMedia')

class Post < Sequel::Model
end

PostResource = Hypa::Resource.new do |r|
  r.properties :id, :title
  r.model Post
end

describe 'A collection' do
  let(:resource) { PostResource }

  let :collection do
    Hypa::Collection.new do |c|
      c.resource PostResource

      c.get :self do |a|
        a.params :title_in
        a.response 200, Hypa::CollectionTemplate.new(c)
      end
    end
  end

  let(:action) { collection.actions[:self] }
  let(:response) { action.responses[200] }

  it 'defines an action' do
    expect(collection.actions.size).to eq(1)

    expect(action.name).to eq(:self)
    expect(action.method).to eq('GET')
    expect(action.params).to eq([:title_in])
    expect(action.responses.size).to eq(1)

    expect(response.status).to eq(200)
  end

  it 'defines a resource' do
    expect(collection.resource).to eq(resource)
  end

  it 'renders an action\'s response' do
    result = collection.actions[:self].responses[200].render(collection.resource.model.all.map(&:values))
    expect(result).to eq([{ id: 1, title: 'HypaMedia' }])
  end
end