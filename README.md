# JsonValidation

JsonValidation validates JSON according to a [JSON Schema](http://json-schema.org/documentation.html).

It is designed to validate as quickly as possible.


## Current limitations

* The library can only say whether a record is valid or not.  In the event that
  a record is not valid, it will not say why.
* The library will only validate against draft v4 of the JSON Schema
  specification.


## Installation

Add this line to your application's Gemfile:

    gem 'json_validation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_validation


## Usage

Load the library:

    require "json_validation"

Build a validator from a hash representing a JSON schema:

    validator = JsonValidation.build_validator(schema)

Load a validator from a schema at a URL or path:

    validator = JsonValidation.load_validator(uri)

Use the validator to validate whether a record validates against a schema.

    validator.validate(record)
    # => returns true or false


### Format validation

To validate a record against a format, define a validator class with a
`#validate` method:

    class DateTimeFormatValidator
      def validate(record)
        Date.parse(record)
        true
      rescue ArgumentError
        false
      end
    end

Then, register the validator:

    JsonValidation.add_format_validator("date-time", DateTimeFormatValidator)


## Contributing

If you find an example of a record being incorrectly validated against a
schema, please raise an issue on GitHub.

You can run the tests with:

    $ bundle exec rake test

A handful of tests require internet access.
