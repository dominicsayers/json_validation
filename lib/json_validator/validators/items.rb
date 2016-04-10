module JsonValidator
  module Validators
    class Items < Validator
      type :array

      def validate(record)
        case fragment['items']
        when Hash
          record.all? {|item| inner_validator.validate(item)}
        when Array
          inner_validators.zip(record).all? {|validator, item|
            validator.validate(item)
          }
        else
          raise "Unexpected type for fragment['items']"
        end
      end

      def inner_validator
        raise unless fragment["items"].is_a?(Hash)
        @inner_validator ||= build_validator(fragment["items"])
      end

      def inner_validators
        raise unless fragment["items"].is_a?(Array)
        @inner_validators ||= fragment["items"].map {|f|
          build_validator(f)
        }
      end
    end
  end
end
