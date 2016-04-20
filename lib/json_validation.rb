require 'bigdecimal'
require 'json'
require 'open-uri'

require 'addressable/uri'

require 'json_validation/schema'
require 'json_validation/schema_validator'
require 'json_validation/validation_failure'
require 'json_validation/validators/validator'
Dir[File.join(File.dirname(__FILE__), 'json_validation', 'validators', '*.rb')].each do |path|
  require path
end
require 'json_validation/version'

module JsonValidation
  extend self

  TYPES_TO_CLASSES = {
    :array => [Array],
    :boolean => [TrueClass, FalseClass],
    :integer => [Integer],
    :number => [Numeric],
    :null => [NilClass],
    :object => [Hash],
    :string => [String],
    :any => [Object],
  }

  def load_validator(uri)
    uri = Addressable::URI.parse(uri) unless uri.is_a?(Addressable::URI)

    schema = load_schema(uri)
    build_validator(schema, uri)
  end

  def build_validator(schema, uri = nil)
    if schema.is_a?(Hash)
      schema = Schema.new(schema, uri)
      schema_cache[schema.base_uri] = schema
    end

    SchemaValidator.new(schema)
  end

  def load_schema(uri)
    raise unless uri.is_a?(Addressable::URI)

    uri = uri.clone
    uri_fragment = uri.fragment
    uri.fragment = nil
    schema = schema_cache[uri]

    schema[uri_fragment]
  end

  def clear_schema_cache
    @schema_cache = nil
  end

  def schema_cache
    @schema_cache ||= Hash.new {|cache, uri|
      schema_data = JSON.parse(open(uri).read)
      schema = Schema.new(schema_data, uri)
      cache[uri] = schema
    }
  end

  def get_format_validator(key)
    format_validators.fetch(key).new
  end

  def add_format_validator(key, format_validator)
    format_validators[key] = format_validator
  end

  def clear_format_validators
    @format_validators = nil
  end

  def format_validators
    @format_validators ||= {}
  end
end
