module JsonValidator
  module Validators
    module MaxItems
      extend self
      extend Validator

      type :array

      def validate(schema, fragment, record)
        fragment['maxItems'] >= record.size
      end
    end
  end
end
