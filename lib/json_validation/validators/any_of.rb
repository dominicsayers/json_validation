module JsonValidation
  module Validators
    class AnyOf < Validator
      type :any

      def validate(record)
        inner_validators.any? {|validator| validator.validate(record)}
      end

      def inner_validators
        @inner_validators ||= fragment["anyOf"].map {|f|
          build_validator(f)
        }
      end
    end
  end
end
