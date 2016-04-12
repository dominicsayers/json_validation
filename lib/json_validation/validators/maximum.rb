module JsonValidation
  module Validators
    class Maximum < Validator
      type :number

      def validate(record)
        if fragment['exclusiveMaximum']
          fragment['maximum'] > record
        else
          fragment['maximum'] >= record
        end
      end
    end
  end
end
