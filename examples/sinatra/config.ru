require 'bundler/setup'
require 'sinatra/base'
require 'sequel'
require 'hypa'

class Blog
  cattr_reader :collections

  @@collections = {}

  def self.collection(name, &block)
    @@collections[name] = Hypa::Collection.new(&block)
  end
end

DB = Sequel.sqlite

DB.create_table :posts do
  primary_key :id
  String :title
end

DB.from(:posts).insert(title: 'HypaMedia')

class Post < Sequel::Model
end

Blog.collection :posts do |c|
  c.href '/posts'
  c.methods get: :self, post: :create

  c.resource do |r|
    r.href '/posts/{id}'
    r.methods get: :self, patch: :update, delete: :destroy

    r.integer :id
    r.string :title
  end

  c.action :self do |a|
    a.integer :limit
    a.array :title_in
  end

  c.action :create do |a|
    a.string :title, required: true
  end
end

# actions = Blog.collections.map { |c| c.resource.actions + c.actions }

# get '*' do
#   Blog.collections.map { |c| c.actions }
# end

# include Sinatra

# before do
#   content_type 'application/hypa+json'
# end

# get '/posts' do
#   template = Blog.collections[:posts]
#   # parameters = template.actions[:self].filter(params)
#   posts = Post.all#(parameters)
#   MultiJson.dump(template.render(posts))
# end

# get '/posts/:id' do
#   template = Blog.collections[:posts]
#   posts = Post.find(params[:id])
#   MultiJson.dump(template.render(posts))
# end

# post '/posts' do
#   template = Blog.collections[:posts]
#   posts = Post.create(template[:schema].filter(params))
#   # 204
# end

# patch '/posts/:id' do

# end

# delete '/posts/:id' do
#   Post.destroy(params[:id])
# end

run Proc.new {}