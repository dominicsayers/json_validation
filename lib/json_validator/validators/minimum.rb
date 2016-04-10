module JsonValidator
  module Validators
    class Minimum < Validator
      type :number

      def validate(record)
        if fragment['exclusiveMinimum']
          fragment['minimum'] < record
        else
          fragment['minimum'] <= record
        end
      end
    end
  end
end
