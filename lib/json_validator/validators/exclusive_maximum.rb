module JsonValidator
  module Validators
    module ExclusiveMaximum
      extend self
      extend Validator

      type :number

      def validate(schema, record)
        true # no-op (handled by Maximum)
      end
    end
  end
end
