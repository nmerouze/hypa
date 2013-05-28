require 'helper'

# TODO: Remove body.body
# TODO: Add json-patch content type for PATCH

describe Hypa::Resource do
  it 'renders a post' do
    post = Post.create(title: 'Foobar')
    status, headers, body = PostResource.call(:get, env, :id => post.id)

    status.must_equal 200
    body.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end

  it 'updates a post' do
    post = Post.create(title: 'Foobar')
    status, headers, body = PostResource.call(:patch, env(method: 'PATCH', input: '[{"op":"replace","path":"/title","value":"Updated post"}]'), :id => post.id)

    status.must_equal 200
    body.body.must_equal('{"posts":[{"title":"Updated post"}]}')
  end

  it 'deletes a post' do
    post = Post.create(title: 'Foobar')
    status, headers, body = PostResource.call(:delete, env, :id => post.id)

    status.must_equal 204
    Post.find_by_id(post.id).must_equal nil
  end
end

describe Hypa::Collection do
  it 'renders posts' do
    post = Post.create(title: 'Foobar')
    status, headers, body = PostsCollection.call(:get, env)

    status.must_equal 200
    body.body.must_equal('{"posts":[{"title":"Foobar"}]}')
  end

  it 'GET /posts creates post' do
    status, headers, body = PostsCollection.call(:post, env, title: 'New post')
    
    status.must_equal 200
    body.body.must_equal('{"posts":[{"title":"New post"}]}')
  end
end