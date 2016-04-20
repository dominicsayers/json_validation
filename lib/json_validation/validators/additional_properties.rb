module JsonValidation
  module Validators
    class AdditionalProperties < Validator
      type :object

      def validate(value, value_path)
        case schema['additionalProperties']
        when true
          true
        when false
          find_additional_properties(schema, value).empty?
        when Schema
          find_additional_properties(schema, value).values.all? {|value|
            inner_validator.validate(value)
          }
        else
          raise "Unexpected type for schema['additionalProperties']"
        end
      end

      def inner_validator
        @inner_validator ||= SchemaValidator.new(schema["additionalProperties"])
      end

      def find_additional_properties(schema, value)
        value.reject {|k, v|
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
