require 'bigdecimal'
require 'json'

require "json_validator/version"
require "json_validator/validator"
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

  def validate(schema, record)
    schema.keys.all? {|key|
      validator_name = key[0].upcase + key[1..-1]
      validator = JsonValidator::Validators.const_get(:"#{validator_name}")
      if TYPES_TO_CLASSES[validator.type.to_s].any? {|klass| record.is_a?(klass)}
        validator.validate(schema, record)
      else
        true
      end
    }
  end
end
