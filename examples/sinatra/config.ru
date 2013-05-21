require 'bundler/setup'
require 'hypa'
require 'sinatra/base'
require 'json'
require 'sequel'

DB = Sequel.sqlite

DB.create_table :posts do
  primary_key :id
  String :title
end

DB.from(:posts).insert(title: 'HypaMedia')

# class Post < Sequel::Model
# end

class MyApp < Sinatra::Base
  def self.custom_stuff(*components)
    components.each do |component|
      component.routes.each do |r|
        route r[0], r[1], {}, &r[2]
      end
    end

    self
  end
end

class Hypa::Collection
  def self.routes
    this = self
    routes = []
    routes << ['OPTIONS', self._actions[:self]._href, Proc.new { JSON.dump(this.to_hash) }]
    
    self._actions.each do |name, action|
      routes << [action._method, action._href, Proc.new { JSON.dump(action.render(this._resource._data_source.call, params)) }]
    end

    routes
  end
end

class Hypa::Resource
  class_inheritable_accessor :_data_source

  def self.data_source(&block)
    self._data_source = block
  end

  def self.routes
    this = self
    routes = []
    routes << ['OPTIONS', self._actions[:self]._href, Proc.new { JSON.dump(this.to_hash) }]
    
    self._actions.each do |name, action|
      routes << [action._method, action._href, Proc.new { JSON.dump(action.render(this._data_source.call, params)) }]
    end

    routes
  end
end

class MyApp::PostResource < Hypa::Resource
  attributes :id, :title
  data_source { DB.from(:posts) }

  class SelfAction < Hypa::Action
    get :self => '/posts/:id'

    response 200, Hypa::ResourceTemplate.new(MyApp::PostResource)
    response 404, status: 'Not found', message: 'This post is missing.'

    def self.render(ds, params)
      if post = ds.filter(id: params[:id]).first
        self._responses[200].render([post])
      else
        self._responses[404].render
      end
    end
  end

  actions :self
end

class MyApp::PostsCollection < Hypa::Collection
  resource :post

  class SelfAction < Hypa::Action
    get :self => '/posts'

    response 200, Hypa::CollectionTemplate.new(MyApp::PostsCollection)

    def self.render(ds, params)
      self._responses[200].render(ds.all)
    end
  end

  actions :self
end

run MyApp.custom_stuff(MyApp::PostsCollection, MyApp::PostResource)