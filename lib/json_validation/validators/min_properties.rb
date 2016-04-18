module JsonValidation
  module Validators
    class MinProperties < Validator
      type :object

      def validate(value, value_path)
        schema['minProperties'] <= value.size
      end
    end
  end
end
