module JsonValidator
  module Validators
    module MaxItems
      extend self
      extend Validator

      type :array

      def validate(schema, record)
        schema['maxItems'] >= record.size
      end
    end
  end
end
