class Post < ActiveRecord::Base
end

class PostResource < Hypa::Resource
  attributes :title
  actions :get, :patch, :delete, :options
end

class PostsCollection < Hypa::Collection
  actions :get, :post, :options
end

class MyApp < Sinatra::Base
  get '/posts', &PostsCollection.action(:get)
  post '/posts', &PostsCollection.action(:post)
  options '/posts', &PostsCollection.action(:options)
  get '/posts/:id', &PostResource.action(:get)
  patch '/posts/:id', &PostResource.action(:patch)
  delete '/posts/:id', &PostResource.action(:delete)
  options '/posts/:id', &PostResource.action(:options)
end