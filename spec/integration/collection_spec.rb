require 'spec_helper'

describe Hypa::Collection, '.new' do
  before do
    @collection = Hypa::Collection.new do |c|
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

    @properties = @collection.to_hash
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
    @collection = Hypa::Collection.new do |c|
      c.schema do |s|
        s.attribute(:title, type: 'string')
      end
    end
  end

  context 'with items' do
    before do
      @properties = @collection.render([{ title: 'My Test Title' }])
    end

    it 'renders items of the collection' do
      expect(@properties[:items]).to eq([{ title: 'My Test Title' }])
    end
  end

  context 'with a single item' do
    before do
      @properties = @collection.render({ title: 'My Test Title' })
    end

    it 'renders items of the collection' do
      expect(@properties[:items]).to eq({ title: 'My Test Title' })
    end
  end
end