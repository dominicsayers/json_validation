module JsonValidator
  module Validators
    module ExclusiveMinimum
      extend self
      extend Validator

      type :number

      def validate(schema, record)
        true # no-op (handled by Minimum)
      end
    end
  end
end
