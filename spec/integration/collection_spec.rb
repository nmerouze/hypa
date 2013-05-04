require 'spec_helper'

describe Hypa::Collection, '.new' do
  before do
    @resource = Hypa::Collection.new do |c|
      c.schema do |s|
        s.attribute(:title, type: 'string')
      end

      c.action do |a|
        a.rel :search
        a.href '/posts/search'

        a.params do |p|
          p.attribute :q, type: 'string'
        end
      end
    end

    @properties = @resource.to_hash
  end

  it 'defines schema' do
    expect(@properties[:schema]).to eq([{ name: 'title', type: 'string' }])
  end

  it 'defines actions' do
    expect(@properties[:actions]).to eq([{ rel: 'search', href: '/posts/search', params: [{ name: 'q', type: 'string' }] }])
  end
end

describe Hypa::Collection, '#render' do
  before do
    @resource = Hypa::Collection.new do |c|
      c.schema do |s|
        s.attribute(:title, type: 'string')
      end
    end

    @properties = @resource.render([{ title: 'My Test Title' }])
  end

  it 'renders items of the resource' do
    expect(@properties[:items]).to eq([{ title: 'My Test Title' }])
  end
end