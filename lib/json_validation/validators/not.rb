module JsonValidation
  module Validators
    class Not < Validator
      type :any

      def validate(value, value_path)
        !inner_validator.validate(value, value_path)
      end

      def inner_validator
        @inner_validator ||= SchemaValidator.new(schema["not"])
      end
    end
  end
end
