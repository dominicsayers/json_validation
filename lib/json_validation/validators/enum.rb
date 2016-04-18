module JsonValidation
  module Validators
    class Enum < Validator
      type :any

      def validate(value, value_path)
        schema['enum'].include?(value)
      end
    end
  end
end
