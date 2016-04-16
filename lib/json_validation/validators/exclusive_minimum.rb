module JsonValidation
  module Validators
    class ExclusiveMinimum < Validator
      type :number

      def validate(record)
        schema['minimum'] < record
      end
    end
  end
end
