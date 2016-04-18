module JsonValidation
  module Validators
    class MinLength < Validator
      type :string

      def validate(value, value_path)
        schema['minLength'] <= value.size
      end
    end
  end
end
