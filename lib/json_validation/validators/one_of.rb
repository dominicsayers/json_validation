module JsonValidation
  module Validators
    class OneOf < Validator
      type :any

      def validate(value, value_path)
        inner_validators.count {|validator| validator.validate(value, value_path)} == 1
      end

      def inner_validators
        @inner_validators ||= schema["oneOf"].each_with_index.map {|f, ix|
          build_validator(f, "oneOf/#{ix}")
        }
      end
    end
  end
end
