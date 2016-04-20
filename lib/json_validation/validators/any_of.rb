module JsonValidation
  module Validators
    class AnyOf < Validator
      type :any

      def validate(value, value_path)
        inner_validators.any? {|validator| validator.validate(value, value_path)}
      end

      def inner_validators
        @inner_validators ||= schema["anyOf"].map {|subschema| SchemaValidator.new(subschema)}
      end
    end
  end
end
