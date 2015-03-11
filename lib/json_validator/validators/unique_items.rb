module JsonValidator
  module Validators
    module UniqueItems
      extend self
      extend Validator

      type :array

      def validate(schema, fragment, record)
        if fragment['uniqueItems']
          record.size == record.uniq.size
        else
          true
        end
      end
    end
  end
end
