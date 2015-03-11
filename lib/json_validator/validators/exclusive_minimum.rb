module JsonValidator
  module Validators
    module ExclusiveMinimum
      extend self
      extend Validator

      type :number

      def validate(schema, fragment, record)
        true # no-op (handled by Minimum)
      end
    end
  end
end
