module JsonValidator
  module Validators
    module UniqueItems
      extend self
      extend Validator

      type :array

      def validate(schema, record)
        if schema['uniqueItems']
          record.size == record.uniq.size
        else
          true
        end
      end
    end
  end
end
