module JsonValidator
  module Validators
    module Items
      extend self
      extend Validator

      type :array

      def validate(schema, record)
        case schema['items']
        when Hash
          record.all? {|item| JsonValidator.validate(schema['items'], item)}
        when Array
          schema['items'].zip(record).all? {|item_schema, item|
            JsonValidator.validate(item_schema, item)
          }
        else
          raise "Unexpected type for schema['items']"
        end
      end
    end
  end
end
