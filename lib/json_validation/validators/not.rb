module JsonValidation
  module Validators
    class Not < Validator
      type :any

      def validate(value, value_path)
        !inner_validator.validate(value, value_path)
      end

      def inner_validator
        @inner_validator ||= build_validator(schema["not"], "not")
      end
    end
  end
end
