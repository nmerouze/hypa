require File.expand_path('../../lib/hypa', __FILE__)
require 'sequel'

Hypa::Database.connection = Sequel.sqlite

Hypa::Database.connection.create_table(:posts) do
  primary_key :id
  String :title
end

Hypa::Database.connection.from(:posts).insert(title: 'What a title!')

class Todo < Hypa::Application
end

Todo.item :post do |i|
  i.href = '/posts/{id}'

  i.data = [
    { name: 'title', value: '{title}', prompt: 'Title' }
  ]
end

Todo.template :post do |t|
  t.data = [
    { name: 'title', value: '', prompt: 'Title' }
  ]
end

Todo.template :search do |t|
  t.data = [
    { name: 'q', value: '', prompt: 'Search' }
  ]
end

Todo.collection :posts do |c|
  c.version = '1.0'
  c.href = '/posts'

  c.links = [
    { rel: 'feed', href: '/posts/feed' }
  ]

  c.queries = [
    { rel: 'search', href: '/posts/search', prompt: 'Search', data: Todo.template(:search).data }
  ]

  c.template = Todo.template(:post)
end

# https://github.com/rkh/mustermann
# https://github.com/awslabs/seahorse