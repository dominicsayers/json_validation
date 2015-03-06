module JsonValidator
  module Validators
    module Default
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        true
      end
    end
  end
end
