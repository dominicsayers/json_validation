module JsonValidation
  module Validators
    class Items < Validator
      type :array

      def validate(value, value_path)
        case schema['items']
        when Schema
          value.each_with_index.all? {|item, ix| inner_validator.validate(item, value_path + [ix.to_s])}
        when Array
          inner_validators.zip(value).all? {|validator, item|
            validator.validate(item)
          }
        else
          raise "Unexpected type for schema['items']"
        end
      end

      def validate_with_errors(value, value_path)
        case schema['items']
        when Schema
          value.each_with_index.map {|item, ix| inner_validator.validate_with_errors(item, value_path + [ix.to_s])}
        when Array
          inner_validators.zip(value).each_with_index.map {|validator_and_item, ix|
            validator, item = validator_and_item
            validator.validate_with_errors(item, value_path + [ix.to_s])
          }
        else
          raise "Unexpected type for schema['items']"
        end
      end

      def inner_validator
        raise unless schema["items"].is_a?(Schema)
        @inner_validator ||= SchemaValidator.new(schema["items"])
      end

      def inner_validators
        raise unless schema["items"].is_a?(Array)
        @inner_validators ||= schema["items"].map {|subschema| SchemaValidator.new(subschema)}
      end
    end
  end
end
