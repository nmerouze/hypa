require 'spec_helper'

Hypa.connection = Sequel.sqlite

class PostsResource < Hypa::Resource
  primary_key :id
  string :title, key: :my_title
end

Hypa.migrate!

describe Hypa::Resource do
  include Rack::Test::Methods

  def app
    Hypa.app
  end

  def post_with(params)
    id = Hypa.connection.from(:posts).insert(params)
    Hypa.connection.from(:posts).filter(id: id).first
  end

  context 'GET /posts/:id' do
    Given(:post) { post_with(title: 'Foobar') }
    When { get "/posts/#{post[:id]}" }
    Then { expect(last_response.status).to eq(200) }
    And  { expect(last_response.body).to eq('{"posts":[{"id":1,"my_title":"Foobar"}]}') }
  end

  context 'POST /posts' do
    When { post "/posts", title: 'New Foobar' }
    Then { expect(last_response.status).to eq(201) }
    And  { expect(last_response.body).to eq('{"posts":[{"id":2,"my_title":"New Foobar"}]}') }
  end
end