# JsonValidator

JsonValidator validates JSON according to a [JSON Schema](http://json-schema.org/documentation.html).

It is designed to validate as quickly as possible.


## Current limitations

* The library can only say whether a record is valid or not.  In the event that
  a record is not valid, it will not say why.
* The library will only validate against draft v4 of the JSON Schema
  specification.


## Installation

Add this line to your application's Gemfile:

    gem 'json_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_validator


## Usage

Load the library:

    require "json_validator"

Build a validator from a hash representing a JSON schema:

    validator = JsonValidator.build_validator(schema)

Load a validator from a schema at a URL or path:

    validator = JsonValidator.load_validator(uri)

Use the validator to validate whether a record validates against a schema.

    validator.validate(record)
    # => returns true or false


## Contributing

If you find an example of a record being incorrectly validated against a
schema, please raise an issue on GitHub.

You can run the tests with:

    $ bundle exec rake test

A handful of tests require internet access.
