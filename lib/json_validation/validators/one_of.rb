module JsonValidation
  module Validators
    class OneOf < Validator
      type :any

      def validate(value, value_path)
        inner_validators.count {|validator| validator.validate(value, value_path)} == 1
      end

      def validate_with_errors(value, value_path)
        failures = inner_validators.map {|validator|
          validator.validate_with_errors(value, value_path)
        }.flatten.compact

        if failures.size != inner_validators.size - 1
          fail_validation(value, value_path, failures)
        else
          nil
        end
      end

      def inner_validators
        @inner_validators ||= schema["oneOf"].map {|subschema| SchemaValidator.new(subschema)}
      end
    end
  end
end
