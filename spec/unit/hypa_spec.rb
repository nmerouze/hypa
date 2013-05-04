require 'spec_helper'

describe Hypa::Attribute, '#initialize' do
  before do
    @attribute = Hypa::Attribute.new(name: 'title', type: 'string')
  end

  it 'stores name' do
    expect(@attribute.name).to eq('title')
  end

  it 'stores type' do
    expect(@attribute.type).to eq('string')
  end
end

describe Hypa::AttributeSet, '#attribute' do
  before do
    @attribute = double('Hypa::Attribute')
    Hypa::Attribute.stub(:new).and_return(@attribute)
    @set = Hypa::AttributeSet.new
  end

  it 'initializes attribute with name and type' do
    Hypa::Attribute.should_receive(:new).with(name: 'title', type: 'string')
    @set.attribute('title', type: 'string')
  end

  it 'stores attribute' do
    @set.attribute('title', type: 'string')
    expect(@set.attributes).to eq([@attribute])
  end
end

# describe Hypa::Action, '#to_hash' do
#   it 'serializes properties to a hash'
#   it 'casts rel to string'
#   it 'casts href to string'
#   it 'serializes params'
# end

# describe Hypa::AttributeSet, '#to_hash' do
#   it 'serializes attributes into an array of hashes'
# end

# describe Hypa::Attribute, '#to_hash' do
#   it 'serializes properties to a hash'
#   it 'casts name to string'
#   it 'casts type to string'
# end

describe Hypa::Application, '.resource' do
  it 'stores a resource' do
    Hypa::Application.resource :posts, &Proc.new {}
    expect(Hypa::Application.resources[:posts]).to be_a(Hypa::Resource)
  end
end