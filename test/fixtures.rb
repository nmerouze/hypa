class Post < ActiveRecord::Base
end

class PostResource < Hypa::Resource
  attributes :title
  actions :get, :delete
end

class PostsCollection < Hypa::Collection
  actions :get, :post
end

# class MyApp < Sinatra::Base
#   get '/posts', &PostsCollection.action(:get)
#   post '/posts', &PostsCollection.action(:post)
#   get '/posts/:id', &PostResource.action(:get)
#   delete '/posts/:id', &PostResource.action(:delete)
# end