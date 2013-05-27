require 'helper'

describe Hypa::Resource do
  include Rack::Test::Methods

  def app; MyApp; end

  it 'GET /posts/:id renders a post' do
    post = Post.create(title: 'Foobar')

    get "/posts/#{post.id}"

    last_response.status.must_equal 200
    last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end

  it 'DELETE /posts/:id deletes a post' do
    delete "/posts/#{@post.id}"
    Post.find_by_id(@post.id).must_equal nil
    last_response.status.must_equal 204
  end
end

describe Hypa::Collection do
  include Rack::Test::Methods

  def app; MyApp; end

  it 'GET /posts renders posts' do
    get '/posts'
    last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end
end