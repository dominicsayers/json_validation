module JsonValidation
  module Validators
    class AdditionalProperties < Validator
      type :object

      def validate(record)
        case fragment['additionalProperties']
        when true
          true
        when false
          find_additional_properties(fragment, record).empty?
        when Hash
          find_additional_properties(fragment, record).values.all? {|value|
            inner_validator.validate(value)
          }
        else
          raise "Unexpected type for fragment['additionalProperties']"
        end
      end

      def inner_validator
        @inner_validator ||= build_validator(fragment["additionalProperties"])
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
