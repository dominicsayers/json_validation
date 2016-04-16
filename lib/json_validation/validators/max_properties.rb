module JsonValidation
  module Validators
    class MaxProperties < Validator
      type :object

      def validate(record)
        schema['maxProperties'] >= record.size
      end
    end
  end
end
