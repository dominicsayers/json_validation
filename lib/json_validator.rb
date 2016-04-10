require 'bigdecimal'
require 'json'
require 'open-uri'

require 'addressable/uri'

require 'json_validator/validator_collection'
require 'json_validator/validators/validator'
Dir[File.join(File.dirname(__FILE__), 'json_validator', 'validators', '*.rb')].each do |path|
  require path
end
require 'json_validator/version'

module JsonValidator
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

    validators = schema.keys.map {|key|
      if key == '$ref'
        validator_name = 'Ref'
      else
        validator_name = key[0].upcase + key[1..-1]
      end

      begin
        klass = JsonValidator::Validators.const_get(:"#{validator_name}")
      rescue NameError
        nil
      else
        klass.new(schema, base_uri)
      end
    }.compact

    ValidatorCollection.new(validators)
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
end
