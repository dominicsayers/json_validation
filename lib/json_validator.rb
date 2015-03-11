require 'bigdecimal'
require 'json'
require 'open-uri'

require 'addressable/uri'

require 'json_validator/version'
require 'json_validator/validator'
Dir[File.join(File.dirname(__FILE__), 'json_validator', 'validators', '*.rb')].each {|path| require path}

module JsonValidator
  extend self

  TYPES_TO_CLASSES = {
    'array' => [Array],
    'boolean' => [TrueClass, FalseClass],  # grr Ruby
    'integer' => [Integer],
    'number' => [Numeric],
    'null' => [NilClass],
    'object' => [Hash],
    'string' => [String],
    'any' => [Object],
  }

  def validate(schema, fragment, record)
    fragment.keys.all? {|key|
      if key == '$ref'
        validator_name = 'Ref'
      else
        validator_name = key[0].upcase + key[1..-1]
      end

      begin
        validator = JsonValidator::Validators.const_get(:"#{validator_name}")
      rescue NameError
        true
      else
        if TYPES_TO_CLASSES[validator.type.to_s].any? {|klass| record.is_a?(klass)}
          validator.validate(schema, fragment, record)
        else
          true
        end
      end
    }
  end

  def load_schema(uri)
    @schema_cache ||= Hash.new {|h, k|
      schema = JSON.parse(open(k).read)
      @schema_cache[k] = schema
    }

    @schema_cache[uri]
  end
end
