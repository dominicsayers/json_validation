module JsonValidation
  module Validators
    class Items < Validator
      type :array

      def validate(record)
        case schema['items']
        when Hash
          record.all? {|item| inner_validator.validate(item)}
        when Array
          inner_validators.zip(record).all? {|validator, item|
            validator.validate(item)
          }
        else
          raise "Unexpected type for schema['items']"
        end
      end

      def inner_validator
        raise unless schema["items"].is_a?(Hash)
        @inner_validator ||= build_validator(schema["items"])
      end

      def inner_validators
        raise unless schema["items"].is_a?(Array)
        @inner_validators ||= schema["items"].map {|f|
          build_validator(f)
        }
      end
    end
  end
end
