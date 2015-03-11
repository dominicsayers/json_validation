module JsonValidator
  module Validators
    module AdditionalProperties
      extend self
      extend Validator

      type :object

      def validate(schema, fragment, record)
        case fragment['additionalProperties']
        when true
          true
        when false
          find_additional_properties(fragment, record).empty?
        when Hash
          find_additional_properties(fragment, record).values.all? {|value|
            JsonValidator.validate(schema, fragment['additionalProperties'], value)
          }
        else
          raise "Unexpected type for fragment['additionalProperties']"
        end
      end

      def find_additional_properties(fragment, record)
        record.reject {|k, v|
          fragment.fetch('properties', {}).keys.include?(k)
        }.reject {|k, v|
          fragment.fetch('patternProperties', {}).keys.any? {|pattern|
            rx = Regexp.new(pattern)
            rx.match(k)
          }
        }
      end
    end
  end
end
