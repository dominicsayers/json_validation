module JsonValidation
  module Validators
    class MaxLength < Validator
      type :string

      def validate(record)
        schema['maxLength'] >= record.size
      end
    end
  end
end
