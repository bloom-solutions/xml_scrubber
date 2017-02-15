# XMLScrubber

[![Build Status](https://travis-ci.org/imacchiato/xml_scrubber.svg?branch=master)](https://travis-ci.org/imacchiato/xml_scrubber)

A simple utility to remove sensitive info from XML. It's like [loofah](https://github.com/flavorjones/loofah) but meant to be simple - to log XML requests and responses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xml_scrubber'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xml_scrubber

## Usage

The following scrubs node names that match with `/password/i` (you can pass regex or a string for an exact match)

```ruby
xml = "<xml><password>sekret</password></xml>"
XMLScrubber.(xml, name: {matches: /password/i}, scrub_with: "*****")
# <xml><password>*****</password></xml>
```

- `ignore_case`: defaults to `true`
- `scrub_with`: defaults to `[filtered]`
- It ignores namespaces (i.e. this still works with `<xml xmlns:x="http://schemas.xmlsoap.org/soap/envelope/"><x:password>sekret</x:password></xml>`)

Specify multiple directives on `name`:

```ruby
XMLScrubber.(
  xml,
  {name: {matches: /password/i},
  {name: {matches: /secret/i},
)
```

The only directive supported at the moment is `name`. Others in the future may include `attr` (for attribute), `content`, etc.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xml_scrubber. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

