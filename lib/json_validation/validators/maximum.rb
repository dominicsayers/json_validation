module JsonValidation
  module Validators
    class Maximum < Validator
      type :number

      def validate(record)
        fragment['maximum'] >= record
      end
    end
  end
end
