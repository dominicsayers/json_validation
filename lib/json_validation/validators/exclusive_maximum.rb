module JsonValidation
  module Validators
    class ExclusiveMaximum < Validator
      type :number

      def validate(record)
        schema['maximum'] > record
      end
    end
  end
end
