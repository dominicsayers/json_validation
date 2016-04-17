module JsonValidation
  module Validators
    class AnyOf < Validator
      type :any

      def validate(record)
        inner_validators.any? {|validator| validator.validate(record)}
      end

      def inner_validators
        @inner_validators ||= schema["anyOf"].each_with_index.map {|f, ix|
          build_validator(f, "anyOf/#{ix}")
        }
      end
    end
  end
end
