module JsonValidator
  module Validators
    class ExclusiveMinimum < Validator
      type :number

      def validate(record)
        true # no-op (handled by Minimum)
      end
    end
  end
end
