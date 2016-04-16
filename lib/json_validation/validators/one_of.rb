module JsonValidation
  module Validators
    class OneOf < Validator
      type :any

      def validate(record)
        inner_validators.count {|validator| validator.validate(record)} == 1
      end

      def inner_validators
        @inner_validators ||= schema["oneOf"].map {|f|
          build_validator(f)
        }
      end
    end
  end
end
