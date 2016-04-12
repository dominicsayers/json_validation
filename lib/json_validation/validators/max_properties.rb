module JsonValidation
  module Validators
    class MaxProperties < Validator
      type :object

      def validate(record)
        fragment['maxProperties'] >= record.size
      end
    end
  end
end
