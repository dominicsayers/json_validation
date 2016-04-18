module JsonValidation
  module Validators
    class Items < Validator
      type :array

      def validate(value, value_path)
        case schema['items']
        when Hash
          value.all? {|item| inner_validator.validate(item)}
        when Array
          inner_validators.zip(value).all? {|validator, item|
            validator.validate(item)
          }
        else
          raise "Unexpected type for schema['items']"
        end
      end

      def inner_validator
        raise unless schema["items"].is_a?(Hash)
        @inner_validator ||= build_validator(schema["items"], "items")
      end

      def inner_validators
        raise unless schema["items"].is_a?(Array)
        @inner_validators ||= schema["items"].each_with_index.map {|f, ix|
          build_validator(f, "items/#{ix}")
        }
      end
    end
  end
end
