require 'bundler/setup'
require 'hypa'

Hypa::Application.resource :post, '/posts/:id' do |r|
  r.properties :id, :title

  r.get :self do |a|
    a.params :id
    a.response 200, Hypa::ResourceTemplate.new(r)
  end
end

run Hypa::Application