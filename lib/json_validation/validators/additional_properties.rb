module JsonValidation
  module Validators
    class AdditionalProperties < Validator
      type :object

      def validate(record)
        case schema['additionalProperties']
        when true
          true
        when false
          find_additional_properties(schema, record).empty?
        when Hash
          find_additional_properties(schema, record).values.all? {|value|
            inner_validator.validate(value)
          }
        else
          raise "Unexpected type for schema['additionalProperties']"
        end
      end

      def inner_validator
        @inner_validator ||= build_validator(schema["additionalProperties"])
      end

      def find_additional_properties(schema, record)
        record.reject {|k, v|
          schema.fetch('properties', {}).keys.include?(k)
        }.reject {|k, v|
          schema.fetch('patternProperties', {}).keys.any? {|pattern|
            rx = Regexp.new(pattern)
            rx.match(k)
          }
        }
      end
    end
  end
end
