require 'bigdecimal'
require 'json'
require 'open-uri'

require 'addressable/uri'

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

  def build_validator(schema, base_uri = nil)
    if base_uri.nil?
      base_uri = generate_uri(schema)
      schema_cache[base_uri] = schema
    end

    SchemaValidator.new(schema, base_uri)
  end

  def generate_uri(schema)
    Addressable::URI.parse(Digest::SHA1.hexdigest(schema.to_json))
  end

  def load_schema(uri)
    raise unless uri.is_a?(Addressable::URI)

    uri = uri.clone
    uri_fragment = uri.fragment
    uri.fragment = nil
    schema = schema_cache[uri]

    return schema if uri_fragment == "" || uri_fragment.nil?

    fragment = schema

    uri_fragment[1..-1].split('/').each do |element|
      element = element.gsub('~0', '~').gsub('~1', '/').gsub('%25', '%')

      case fragment
      when Hash
        if fragment.has_key?(element)
          fragment = fragment[element]
          next
        end
      when Array
        begin
          ix = Integer(element)
          if ix < fragment.size
            fragment = fragment[ix]
            next
          end
        rescue ArgumentError
        end
      else
        raise "Could not look up #{uri_fragment} in #{schema}"
      end
    end

    fragment
  end

  def clear_schema_cache
    @schema_cache = nil
  end

  def schema_cache
    @schema_cache ||= Hash.new {|cache, uri|
      cache[uri] = JSON.parse(open(uri).read)
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
