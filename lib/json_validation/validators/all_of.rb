module JsonValidation
  module Validators
    class AllOf < Validator
      type :any

      def validate(value, value_path)
        inner_validators.all? {|validator| validator.validate(value, value_path)}
      end

      def inner_validators
        @inner_validators ||= schema["allOf"].map {|subschema| SchemaValidator.new(subschema)}
      end
    end
  end
end
