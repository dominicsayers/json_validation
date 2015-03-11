module JsonValidator
  module Validators
    module Not
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        !JsonValidator.validate(schema, fragment['not'], record)
      end
    end
  end
end
