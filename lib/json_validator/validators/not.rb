module JsonValidator
  module Validators
    module Not
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        !JsonValidator.validate(schema['not'], record)
      end
    end
  end
end
