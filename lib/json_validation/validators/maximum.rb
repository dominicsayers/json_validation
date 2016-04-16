module JsonValidation
  module Validators
    class Maximum < Validator
      type :number

      def validate(record)
        schema['maximum'] >= record
      end
    end
  end
end
