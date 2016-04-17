module JsonValidation
  module Validators
    class AllOf < Validator
      type :any

      def validate(record)
        inner_validators.all? {|validator| validator.validate(record)}
      end

      def inner_validators
        @inner_validators ||= schema["allOf"].each_with_index.map {|f, ix|
          build_validator(f, "allOf/#{ix}")
        }
      end
    end
  end
end
