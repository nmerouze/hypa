require 'spec_helper'

describe Hypa::Application do
  before do
    class MockApp < Hypa::Application; end
  end

  after do
    Object.send(:remove_const, :MockApp)
  end

  describe '.resource' do
    let(:resource) { MockApp.resource :post, '/posts/:id' }

    it 'stores a resource' do
      expect(MockApp.resources[:post]).to be_nil
      resource
      expect(MockApp.resources[:post]).to eq(resource)
    end

    it 'add an OPTIONS route' do
      expect(MockApp.routes['OPTIONS']).to be_nil
      resource
      expect(MockApp.routes['OPTIONS']).to_not be_nil
    end
  end

  describe '.collection' do
    let(:collection) { MockApp.collection :posts, '/posts' }

    it 'stores a collection' do
      expect(MockApp.collections[:posts]).to be_nil
      collection
      expect(MockApp.collections[:posts]).to eq(collection)
    end

    it 'add an OPTIONS route' do
      expect(MockApp.routes['OPTIONS']).to be_nil
      collection
      expect(MockApp.routes['OPTIONS']).to_not be_nil
    end
  end
end