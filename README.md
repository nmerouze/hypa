# Hypa: Web Framework to make Hypermedia APIs

[![Gem Version](https://badge.fury.io/rb/hypa.png)](http://rubygems.org/gems/hypa) [![Build Status](https://travis-ci.org/nmerouze/hypa.png?branch=master)](https://travis-ci.org/nmerouze/hypa) [![Code Climate](https://codeclimate.com/github/nmerouze/hypa.png)](https://codeclimate.com/github/nmerouze/hypa) [![Dependency Status](https://gemnasium.com/nmerouze/hypa.png)](https://gemnasium.com/nmerouze/hypa) [![Coverage Status](https://coveralls.io/repos/nmerouze/hypa/badge.png?branch=master)](https://coveralls.io/r/nmerouze/hypa)

# Proof-of-concept

The framework right now just serializes a given representation and wrap it in an OPTIONS action in a Sinatra app. This project is really young, it will evolves to something more automated in the future. I like the DSL from [Weasel Diesel](https://github.com/mattetti/Weasel-Diesel), that's why it looks like it.

# List of Hypermedia content types

Hypa is using its own content type "application/vnd.hypa+json" (far from being finalized). I like JSON API and the data part will try to follow this spec. The metadata part is similar to the actions from Siren.

* [Collection+JSON](http://amundsen.com/media-types/collection/)
* [HAL](http://stateless.co/hal_specification.html)
* [Siren](https://github.com/kevinswiber/siren)
* [JSON API](http://jsonapi.org)