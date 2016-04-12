module JsonValidation
  module Validators
    class AdditionalItems < Validator
      type :array

      def validate(record)
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
              inner_validator.validate(item)
            }
          else
            raise "Unexpected type for fragment['additionalItems']"
          end
        end
      end

      def inner_validator
        @inner_validator ||= build_validator(fragment["additionalItems"])
      end

      def find_additional_items(fragment, record)
        record.drop(fragment['items'].size)
      end
    end
  end
end
