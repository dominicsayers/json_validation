module JsonValidation
  module Validators
    class Format < Validator
      type :any

      def validate(value, value_path)
        inner_validator.validate(value, value_path)
      end

      def inner_validator
        @inner_validator ||= JsonValidation.get_format_validator(schema["format"])
      end
    end
  end
end
