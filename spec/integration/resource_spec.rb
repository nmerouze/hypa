require 'spec_helper'

describe 'Hypa::Resource.new' do
  before do
    @resource = Hypa::Resource.new do |r|
      r.schema do |s|
        s.attribute(:title, type: 'string')
      end

      r.action do |a|
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