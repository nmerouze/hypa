# encoding: utf-8

require 'spec_helper'

describe Hypa::Attribute do
  it 'stores name' do
    a = Hypa::Attribute.new(:name => 'full_name')
    expect(a.name).to eq('full_name')
  end

  it 'stores value' do
    a = Hypa::Attribute.new(:value => 'Nicolas Mérouze')
    expect(a.value).to eq('Nicolas Mérouze')
  end

  it 'stores prompt' do
    a = Hypa::Attribute.new(:prompt => 'Full Name')
    expect(a.prompt).to eq('Full Name')
  end
end

describe Hypa::Link do
  it 'stores rel' do
    l = Hypa::Link.new(:rel => 'feed')
    expect(l.rel).to eq('feed')
  end

  it 'stores href' do
    l = Hypa::Link.new(:href => 'http://example.org/posts/feed')
    expect(l.href).to eq('http://example.org/posts/feed')
  end
end

describe Hypa::Item do
  it 'stores href' do
    i = Hypa::Item.new(:href => 'http://example.org/posts/1')
    expect(i.href).to eq('http://example.org/posts/1')
  end

  it 'stores data' do
    a = Hypa::Attribute.new
    item = Hypa::Item.new(:data => [a])
    expect(item.data).to eq([a])
  end

  it 'stores links' do
    i = Hypa::Item.new(:links => [])
    expect(i.links).to eq([])
  end
end

describe Hypa::Item, '#render' do
  before do
    @item = Hypa::Item.new(href: '/posts/{id}', data: [
      { name: 'title', value: '{title}', prompt: 'Title' }
    ])
    @item.render(id: 1, title: 'My Custom Title')
  end

  it 'renders href with passed data' do
    expect(@item.href).to eq('/posts/1')
  end

  it 'renders data values with passed data' do
    expect(@item.data.first[:value]).to eq('My Custom Title')
  end
end

describe Hypa::Template do
  it 'stores data' do
    a = Hypa::Attribute.new
    t = Hypa::Template.new(:data => [a])
    expect(t.data).to eq([a])
  end
end

describe Hypa::Query do
  it 'stores data' do
    a = Hypa::Attribute.new
    q = Hypa::Query.new(:data => [a])
    expect(q.data).to eq([a])
  end

  it 'stores rel' do
    q = Hypa::Query.new(:rel => 'feed')
    expect(q.rel).to eq('feed')
  end

  it 'stores href' do
    q = Hypa::Link.new(:href => 'http://example.org/posts/feed')
    expect(q.href).to eq('http://example.org/posts/feed')
  end

  it 'stores prompt' do
    q = Hypa::Query.new(:prompt => 'Full Name')
    expect(q.prompt).to eq('Full Name')
  end
end

describe Hypa::Collection do
  it 'stores version' do
    c = Hypa::Collection.new(:version => '1.0')
    expect(c.version).to eq('1.0')
  end

  it 'stores href' do
    c = Hypa::Collection.new(:href => 'http://example.org/posts/')
    expect(c.href).to eq('http://example.org/posts/')
  end

  it 'stores links' do
    l = Hypa::Link.new
    c = Hypa::Collection.new(:links => [l])
    expect(c.links).to eq([l])
  end

  it 'stores items' do
    i = Hypa::Item.new
    c = Hypa::Collection.new(:items => [i])
    expect(c.items).to eq([i])
  end

  it 'stores queries' do
    q = Hypa::Query.new
    c = Hypa::Collection.new(:queries => [q])
    expect(c.queries).to eq([q])
  end

  it 'stores template' do
    t = Hypa::Template.new
    c = Hypa::Collection.new(:template => t)
    expect(c.template).to eq(t)
  end
end

describe Hypa::Application, '.template' do
  before do
    @template = Hypa::Template.new
    Hypa::Template.stub(:new => @template)

    Hypa::Application.template :mock do |t|
      t.data = [
        { name: 'full_name', value: '', prompt: 'Full Name' }
      ]
    end
  end
  
  context 'with block' do
    it 'initializes a template with block' do
      expect(@template.data.size).to eq(1)
      expect(@template.data.first.attributes).to eq(name: 'full_name', value: '', prompt: 'Full Name')
    end

    it 'stores a template' do
      expect(Hypa::Application.templates).to eq({ mock: @template })
    end
  end

  context 'without block' do
    it 'returns a template' do
      expect(Hypa::Application.template(:mock)).to eq(@template)
    end
  end
end

describe Hypa::Application, '.collection' do
  before do
    @collection = Hypa::Collection.new
    Hypa::Collection.stub(:new => @collection)

    Hypa::Application.collection :mock do |c|
      c.version = 'custom version'
    end
  end
  
  context 'with block' do
    it 'initializes a collection with block' do
      expect(@collection.version).to eq('custom version')
    end

    it 'stores a collection' do
      expect(Hypa::Application.collections).to eq(mock: @collection)
    end
  end

  context 'without block' do
    it 'returns a collection' do
      expect(Hypa::Application.collection(:mock)).to eq(@collection)
    end
  end
end

describe Hypa::Application, '.item' do
  before do
    @item = Hypa::Item.new
    Hypa::Item.stub(:new => @item)

    Hypa::Application.item :mock do |i|
      i.href = '/posts/{id}'
    end
  end
  
  context 'with block' do
    it 'initializes am item with block' do
      expect(@item.href).to eq('/posts/{id}')
    end

    it 'stores a item' do
      expect(Hypa::Application.items).to eq(mock: @item)
    end
  end

  context 'without block' do
    it 'returns a item' do
      expect(Hypa::Application.item(:mock)).to eq(@item)
    end
  end
end

describe 'GET /:collection' do
  include Rack::Test::Methods

  def app
    Hypa::Application
  end

  context 'with existing collection' do
    before do
      Hypa::Database.stub(:all).and_return([{id: 1234, title: 'My Test'}])
      item
      template
      collection
      get '/posts'
    end

    it 'renders collection' do
      expect(last_response.body).to eq(MultiJson.dump(app.collection(:posts), mode: :compat))
    end

    it 'renders items' do
      body = MultiJson.load(last_response.body)

      expect(body['items'][0]).to eq({
        'href' => '/posts/1234',

        'links' => [],

        'data' => [
          { 'name' => 'title', 'value' => 'My Test', 'prompt' => 'Title' }
        ]
      })
    end
  end

  context 'withouth existing collection' do
    before do
      template
      collection
      get '/fakes'
    end

    it 'renders 404' do
      expect(last_response.status).to eq(404)
    end
  end

  def item
    app.item :post do |i|
      i.href = '/posts/{id}'

      i.data = [
        { name: 'title', value: '{title}', prompt: 'Title' },
      ]
    end
  end

  def template
    app.template :post do |t|
      t.data = [
        { name: 'title', value: '', prompt: 'Title' },
        { name: 'body', value: '', prompt: 'Body' }
      ]
    end
  end

  def collection
    app.collection :posts do |c|
      c.version = '1.0'
      c.href = '/posts'

      c.template = app.template(:post)
    end
  end
end