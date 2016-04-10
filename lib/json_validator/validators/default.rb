module JsonValidator
  module Validators
    class Default < Validator
      type :any

      def validate(record)
        true
      end
    end
  end
end
