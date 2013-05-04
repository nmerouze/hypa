require 'spec_helper'

describe 'Hypa::Action.new' do
  before do
    @action = Hypa::Action.new do |a|
      a.rel :self
      a.href '/posts'

      a.params do |p|
        p.attribute :title, type: 'string'
      end
    end

    @properties = @action.to_hash
  end

  it 'defines rel, href and params' do
    expect(@properties[:rel]).to eq('self')
    expect(@properties[:href]).to eq('/posts')
    expect(@properties[:params]).to eq([{ name: 'title', type: 'string' }])
  end
end