module JsonValidation
  module Validators
    class AllOf < Validator
      type :any

      def validate(value, value_path)
        inner_validators.all? {|validator| validator.validate(value, value_path)}
      end

      def validate_with_errors(value, value_path)
        failures = inner_validators.map {|validator|
          validator.validate_with_errors(value, value_path)
        }.flatten.compact

        if failures.any?
          fail_validation(value, value_path, failures)
        else
          nil
        end
      end

      def inner_validators
        @inner_validators ||= schema["allOf"].map {|subschema| SchemaValidator.new(subschema)}
      end
    end
  end
end
