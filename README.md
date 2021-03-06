# Hypa: Web Framework to make Hypermedia APIs

[![Gem Version](https://badge.fury.io/rb/hypa.png)](http://rubygems.org/gems/hypa) [![Build Status](https://travis-ci.org/nmerouze/hypa.png?branch=master)](https://travis-ci.org/nmerouze/hypa) [![Code Climate](https://codeclimate.com/github/nmerouze/hypa.png)](https://codeclimate.com/github/nmerouze/hypa) [![Dependency Status](https://gemnasium.com/nmerouze/hypa.png)](https://gemnasium.com/nmerouze/hypa) [![Coverage Status](https://coveralls.io/repos/nmerouze/hypa/badge.png?branch=master)](https://coveralls.io/r/nmerouze/hypa)

# Proof-of-concept

I'm quickly iterating over different systems and syntaxes. So right now this is just a playground.

# Status

A resource defines a schema which will be used for persistence and serialization. Hypa.app is dealing with requests and responses so you don't have to. All you have to do is: connect to a DB and create resource classes. See example:

    Hypa.connection = Sequel.sqlite

    class PostsResource
      primary_key :id
      string :title, key: :my_title
    end

    Hypa.migrate!

    run Hypa.app

# List of Hypermedia content types

Hypa is using its own content type "application/vnd.hypa+json" (far from being finalized). I like JSON API and the data part will try to follow this spec. The metadata part is similar to the actions from Siren.

* [Collection+JSON](http://amundsen.com/media-types/collection/)
* [HAL](http://stateless.co/hal_specification.html)
* [Siren](https://github.com/kevinswiber/siren)
* [JSON API](http://jsonapi.org)