module JsonValidator
  module Validators
    module AdditionalItems
      extend self
      extend Validator

      type :array

      def validate(schema, record)
        if !schema.has_key?('items') || schema['items'].is_a?(Hash)
          true
        else
          case schema['additionalItems']
          when true
            true
          when false
            find_additional_items(schema, record).empty?
          when Hash
            find_additional_items(schema, record).all? {|item|
              JsonValidator.validate(schema['additionalItems'], item)
            }
          else
            raise "Unexpected type for schema['additionalItems']"
          end
        end
      end

      def find_additional_items(schema, record)
        record.drop(schema['items'].size)
      end
    end
  end
end
