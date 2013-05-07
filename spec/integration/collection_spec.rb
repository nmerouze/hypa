require 'spec_helper'

# describe Hypa::Collection, '.new' do
#   before do
#     @collection = Hypa::Collection.new do |c|
#       c.resource @resource

#       c.action :self, get: '/posts{?limit,offset,title_in}'

#       c.action :create, post: '/posts' do |a|
#         a.template do |t|
#           t.attribute :title, type: 'string'
#         end
#       end
#     end

#     @properties = @collection.to_hash
#   end

#   it 'defines resource' do
#     expect(@properties[:resource]).to eq({
#       attributes: [{ name: 'id', type: 'integer' },{ name: 'title', type: 'string' }],
#       actions: [{ rel: 'self', method: 'get', href: '/posts/{id}' }]
#     })
#   end

#   it 'defines actions' do
#     expect(@properties[:actions]).to eq([
#       { rel: 'self', method: 'get', href: '/posts{?limit,offset,title_in}' },
#       { rel: 'create', method: 'post', href: '/posts', template: [{ name: 'title', type: 'string' }] }
#     ])
#   end
# end