module JsonValidator
  module Validators
    module ExclusiveMaximum
      extend self
      extend Validator

      type :number

      def validate(schema, fragment, record)
        true # no-op (handled by Maximum)
      end
    end
  end
end
