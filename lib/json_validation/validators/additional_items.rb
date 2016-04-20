module JsonValidation
  module Validators
    class AdditionalItems < Validator
      type :array

      def validate(value, value_path)
        if !schema.has_key?('items') || schema['items'].is_a?(Schema)
          true
        else
          case schema['additionalItems']
          when true
            true
          when false
            find_additional_items(schema, value).empty?
          when Schema
            find_additional_items(schema, value).all? {|item, ix|
              inner_validator.validate(item, value_path + [ix.to_s])
            }
          else
            raise "Unexpected type for schema['additionalItems']"
          end
        end
      end

      def validate_with_errors(value, value_path)
        if !schema.has_key?('items') || schema['items'].is_a?(Schema)
          nil
        else
          case schema['additionalItems']
          when true
            nil
          when false
            if find_additional_items(schema, value).empty?
              nil
            else
              fail_validation(value, value_path)
            end
          when Schema
            failures = find_additional_items(schema, value).map {|item, ix|
              inner_validator.validate_with_errors(item, value_path + [ix.to_s])
            }.flatten.compact

            if failures.any?
              fail_validation(value, value_path, failures)
            else
              nil
            end
          else
            raise "Unexpected type for schema['additionalItems']"
          end
        end
      end

      def inner_validator
        @inner_validator ||= SchemaValidator.new(schema["additionalItems"])
      end

      def find_additional_items(schema, value)
        value.each_with_index.drop(schema['items'].size)
      end
    end
  end
end
