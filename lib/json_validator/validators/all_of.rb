module JsonValidator
  module Validators
    class AllOf < Validator
      type :any

      def validate(record)
        inner_validators.all? {|validator| validator.validate(record)}
      end

      def inner_validators
        @inner_validators ||= fragment["allOf"].map {|f|
          build_validator(f)
        }
      end
    end
  end
end
