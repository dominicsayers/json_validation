module JsonValidator
  module Validators
    class Format < Validator
      type :any

      def validate(record)
        inner_validator.validate(record)
      end

      def inner_validator
        @inner_validator ||= JsonValidator.get_format_validator(fragment["format"])
      end
    end
  end
end
