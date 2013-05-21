require 'spec_helper'

describe Hypa::Resource, '.attributes' do
  let(:resource) { Class.new(described_class) }

  before do
    stub_const('PostResource', resource)
  end

  it 'defines attributes' do
    resource.attributes :id, :title

    expect(resource.to_hash).to eq({
      name: :post,
      resources: { post: { attributes: [:id, :title] } }
    })
  end
end

describe Hypa::Resource, '.actions' do
  let(:action) { Class.new(Hypa::Action) { get :self => '/posts' } }
  let(:resource) { Class.new(described_class) }

  before do
    stub_const('PostResource', resource)
    stub_const('PostResource::SelfAction', action)
  end

  it 'references to actions' do
    resource.actions :self

    expect(resource.to_hash).to eq({
      name: :post,
      actions: { :self => { name: :self, method: 'GET', href: '/posts' } }
    })
  end
end

describe Hypa::Collection, '.resource' do
  let(:resource) { Class.new(Hypa::Resource) { attributes(:id, :title) } }
  let(:collection) { Class.new(described_class) }

  before do
    stub_const('PostsCollection', collection)
    stub_const('PostResource', resource)
  end

  it 'references to a resource' do
    collection.resource :post
    
    expect(collection.to_hash).to eq({
      name: :posts,
      resources: { post: { attributes: [:id, :title] } }
    })
  end
end

describe Hypa::Collection, '.actions' do
  let(:action) { Class.new(Hypa::Action) { get :self => '/posts' } }
  let(:collection) { Class.new(described_class) }

  before do
    stub_const('PostsCollection', collection)
    stub_const('PostsCollection::SelfAction', action)
  end

  it 'references to actions' do
    collection.actions :self

    expect(collection.to_hash).to eq({
      name: :posts,
      actions: { :self => { name: :self, method: 'GET', href: '/posts' } }
    })
  end
end

describe Hypa::Action, '.get' do
  let(:action) { Class.new(described_class) }

  it 'defines name, method and href' do
    action.get :self => '/posts'

    expect(action.to_hash).to eq({
      name: :self, method: 'GET', href: '/posts'
    })
  end
end

describe Hypa::Action, '.params' do
  let(:action) { Class.new(described_class) }

  it 'defines params' do
    action.params :title_in

    expect(action.to_hash).to eq({
      params: [:title_in]
    })
  end
end

describe Hypa::Action, '.response' do
  let(:action) { Class.new(described_class) }

  it 'defines response' do
    action.response 404, status: 'Not found', message: 'Post not found.'

    expect(action.to_hash).to eq({
      responses: { 404 => { status: 'Not found', message: 'Post not found.' } }
    })
  end
end

describe Hypa::Template, '#render' do
  let(:template) { described_class.new(status: 'Not found', message: 'Post not found.') }

  it 'renders template' do
    expect(template.render).to eq(status: 'Not found', message: 'Post not found.')
  end
end

describe Hypa::ResourceTemplate, '#to_hash' do
  let(:resource) { stub_const('PostResource', Class.new(Hypa::Resource)) }
  let(:template) { described_class.new(resource) }

  it 'renders template of the resource' do
    expect(template.to_hash).to eq(type: 'array', items: { '$ref' => '#/resources/post' })
  end
end

describe Hypa::ResourceTemplate, '#render' do
  let(:resource) { stub_const('PostResource', Class.new(Hypa::Resource) { attributes :id, :title }) }
  let(:template) { described_class.new(resource) }
  let(:data) { [{ id: 1, title: 'Foobar', fake_attribute: 'Fake' }] }

  it 'renders data' do
    expect(template.render(data)).to eq([{ id: 1, title: 'Foobar' }])
  end
end