module JsonValidation
  module Validators
    class ExclusiveMaximum < Validator
      type :number

      def validate(record)
        fragment['maximum'] > record
      end
    end
  end
end
