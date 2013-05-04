# Hypa: Web Framework to make Hypermedia APIs

[![Gem Version](https://badge.fury.io/rb/hypa.png)](http://rubygems.org/gems/hypa) [![Build Status](https://travis-ci.org/nmerouze/hypa.png?branch=master)](https://travis-ci.org/nmerouze/hypa) [![Code Climate](https://codeclimate.com/github/nmerouze/hypa.png)](https://codeclimate.com/github/nmerouze/hypa) [![Dependency Status](https://gemnasium.com/nmerouze/hypa.png)](https://gemnasium.com/nmerouze/hypa) [![Coverage Status](https://coveralls.io/repos/nmerouze/hypa/badge.png?branch=master)](https://coveralls.io/r/nmerouze/hypa)

# List of Hypermedia content types

Hypa is using its own content type "application/vnd.hypa+json" (not yet finalized). I'll explain soon why I don't use one of the following.

* [Collection+JSON](http://amundsen.com/media-types/collection/)
* [HAL](http://stateless.co/hal_specification.html)
* [Siren](https://github.com/kevinswiber/siren)
* [JSON API](http://jsonapi.org)

# TODO

* Root element should be the name of the collection
* Refactoring and improve Collection#render
* Nested attribute sets
* Filter a hash through action params
* More features (descriptions, validations, etc)