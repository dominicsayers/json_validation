module JsonValidation
  module Validators
    class ExclusiveMinimum < Validator
      type :number

      def validate(value, value_path)
        schema['minimum'] < value
      end
    end
  end
end
