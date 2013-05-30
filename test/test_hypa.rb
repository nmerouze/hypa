require 'helper'

describe 'A response' do
  it 'has a application/vnd.api+json Content-Type' do
    post = Post.create(title: 'Foobar')

    get '/posts'
    last_response.headers['Content-Type'].must_equal 'application/vnd.api+json'
    
    get "/posts/#{post.id}"
    last_response.headers['Content-Type'].must_equal 'application/vnd.api+json'
  end
end

describe Hypa::Resource, 'OPTIONS' do
  it 'returns resource options' do
    post = Post.create(title: 'Foobar')
    options "/posts/#{post.id}"

    last_response.status.must_equal 200
    last_response.headers['Allow'].must_equal 'GET,PATCH,DELETE,OPTIONS'
  end
end

describe Hypa::Resource, 'GET' do
  it 'renders a post' do
    post = Post.create(title: 'Foobar')
    get "/posts/#{post.id}"

    last_response.status.must_equal 200
    last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end
end

describe Hypa::Resource, 'PATCH' do
  it 'updates a post' do
    post = Post.create(title: 'Foobar')
    header 'Content-Type', 'application/json-patch+json'
    patch "/posts/#{post.id}", '[{"op":"replace","path":"/title","value":"Updated post"}]'

    last_response.status.must_equal 204
  end

  describe 'without correct media type' do
    it 'returns 415 Unsupported Media Type' do
      post = Post.create(title: 'Foobar')
      patch "/posts/#{post.id}", '[{"op":"replace","path":"/title","value":"Updated post"}]'

      last_response.status.must_equal 415
    end
  end
end

describe Hypa::Resource do
  it 'deletes a post' do
    post = Post.create(title: 'Foobar')
    delete "/posts/#{post.id}"

    last_response.status.must_equal 204
    Post.find_by_id(post.id).must_equal nil
  end
end

describe Hypa::Collection, 'GET' do
  it 'renders posts' do
    post = Post.create(title: 'Foobar')
    get '/posts'

    last_response.status.must_equal 200
    last_response.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end
end

describe Hypa::Collection, 'POST' do
  it 'creates post' do
    post = Post.create(title: 'Foobar')
    header 'Content-Type', 'application/json'
    post '/posts', '{"posts":[{"title":"New post"}]}'
    
    last_response.status.must_equal 201
    last_response.headers['Location'].must_equal "/posts/#{Post.last.id}"
    last_response.body.must_equal('{"posts":[{"title":"New post"}]}')
  end

  describe 'without correct media type' do
    it 'returns 415 Unsupported Media Type' do
      post "/posts", '{"posts":[{"title":"New post"}]}'

      last_response.status.must_equal 415
    end
  end
end

describe Hypa::Collection, 'OPTIONS' do
  it 'returns collection options' do
    options '/posts'

    last_response.status.must_equal 200
    last_response.headers['Allow'].must_equal 'GET,POST,OPTIONS'
  end
end