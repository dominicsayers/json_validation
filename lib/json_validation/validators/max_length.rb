module JsonValidation
  module Validators
    class MaxLength < Validator
      type :string

      def validate(value, value_path)
        schema['maxLength'] >= value.size
      end
    end
  end
end
