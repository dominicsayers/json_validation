module JsonValidation
  module Validators
    class ExclusiveMaximum < Validator
      type :number

      def validate(value, value_path)
        schema['maximum'] > value
      end
    end
  end
end
