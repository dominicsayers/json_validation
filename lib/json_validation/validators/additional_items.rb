module JsonValidation
  module Validators
    class AdditionalItems < Validator
      type :array

      def validate(value, value_path)
        if !schema.has_key?('items') || schema['items'].is_a?(Hash)
          true
        else
          case schema['additionalItems']
          when true
            true
          when false
            find_additional_items(schema, value).empty?
          when Hash
            find_additional_items(schema, value).all? {|item|
              inner_validator.validate(item)
            }
          else
            raise "Unexpected type for schema['additionalItems']"
          end
        end
      end

      def inner_validator
        @inner_validator ||= build_validator(schema["additionalItems"], "additionalItems")
      end

      def find_additional_items(schema, value)
        value.drop(schema['items'].size)
      end
    end
  end
end
