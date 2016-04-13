module JsonValidation
  module Validators
    class ExclusiveMinimum < Validator
      type :number

      def validate(record)
        fragment['minimum'] < record
      end
    end
  end
end
