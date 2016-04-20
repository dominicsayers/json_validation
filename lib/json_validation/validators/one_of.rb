module JsonValidation
  module Validators
    class OneOf < Validator
      type :any

      def validate(value, value_path)
        inner_validators.count {|validator| validator.validate(value, value_path)} == 1
      end

      def inner_validators
        @inner_validators ||= schema["oneOf"].map {|subschema| SchemaValidator.new(subschema)}
      end
    end
  end
end
