module JsonValidator
  module Validators
    module Items
      extend self
      extend Validator

      type :array

      def validate(schema, fragment, record)
        case fragment['items']
        when Hash
          record.all? {|item| JsonValidator.validate(schema, fragment['items'], item)}
        when Array
          fragment['items'].zip(record).all? {|item_fragment, item|
            JsonValidator.validate(schema, item_fragment, item)
          }
        else
          raise "Unexpected type for fragment['items']"
        end
      end
    end
  end
end
