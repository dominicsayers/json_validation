module JsonValidator
  module Validators
    module AdditionalProperties
      extend self
      extend Validator

      type :object

      def validate(schema, record)
        case schema['additionalProperties']
        when true
          true
        when false
          find_additional_properties(schema, record).empty?
        when Hash
          find_additional_properties(schema, record).values.all? {|value|
            JsonValidator.validate(schema['additionalProperties'], value)
          }
        else
          raise "Unexpected type for schema['additionalProperties']"
        end
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
