require 'helper'

describe Hypa::Resource do
  it 'GET /posts/:id renders a post' do
    post = Post.create(title: 'Foobar')

    get "/posts/#{post.id}"

    last_response.status.must_equal 200
    #last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end

  it 'DELETE /posts/:id deletes a post' do
    post = Post.create(title: 'Foobar')

    delete "/posts/#{post.id}"

    last_response.status.must_equal 204
    Post.find_by_id(post.id).must_equal nil
  end
end

describe Hypa::Collection do
  it 'GET /posts renders posts' do
    post = Post.create(title: 'Foobar')

    get '/posts'
    
    last_response.status.must_equal 200
    last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end
end