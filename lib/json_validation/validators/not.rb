module JsonValidation
  module Validators
    class Not < Validator
      type :any

      def validate(record)
        !inner_validator.validate(record)
      end

      def inner_validator
        @inner_validator ||= build_validator(schema["not"], "not")
      end
    end
  end
end
