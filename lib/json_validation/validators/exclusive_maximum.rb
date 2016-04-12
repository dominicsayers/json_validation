module JsonValidation
  module Validators
    class ExclusiveMaximum < Validator
      type :number

      def validate(record)
        true # no-op (handled by Maximum)
      end
    end
  end
end
