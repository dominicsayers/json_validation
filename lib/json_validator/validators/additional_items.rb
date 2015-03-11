module JsonValidator
  module Validators
    module AdditionalItems
      extend self
      extend Validator

      type :array

      def validate(schema, fragment, record)
        if !fragment.has_key?('items') || fragment['items'].is_a?(Hash)
          true
        else
          case fragment['additionalItems']
          when true
            true
          when false
            find_additional_items(fragment, record).empty?
          when Hash
            find_additional_items(fragment, record).all? {|item|
              JsonValidator.validate(schema, fragment['additionalItems'], item)
            }
          else
            raise "Unexpected type for fragment['additionalItems']"
          end
        end
      end

      def find_additional_items(fragment, record)
        record.drop(fragment['items'].size)
      end
    end
  end
end
