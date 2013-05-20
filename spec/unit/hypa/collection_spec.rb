require 'spec_helper'

describe Hypa::Collection do
  let(:collection) { described_class.new(name: :posts, href: '/posts') }
  subject { collection }

  it 'stores resource' do
    resource = Hypa::Resource.new
    expect(collection.resource).to be_nil
    collection.resource(resource)
    expect(collection.resource).to eq(resource)
  end

  it_has_behavior 'defining actions'

  describe '#to_hash' do
    it 'serializes the object' do
      expect(collection.to_hash).to eq({ name: :posts, href: '/posts', actions: [] })
    end
  end

  # describe '#render' do
  #   before do
  #     post = double('Post', all: [{ id: 1, title: 'Foobar' }])
  #     resource = double('Hypa::Resource', properties: [:id, :title], model: post, to_hash: {})
  #     collection.resource(resource)
  #     collection.get :self do |a|
  #       a.response 200, Hypa::CollectionTemplate.new(collection)
  #     end
  #   end

  #   it 'renders an action\'s response' do
  #     result = collection.render(:self)
  #     expect(result).to eq([{ id: 1, title: 'Foobar' }])
  #   end
  # end
end