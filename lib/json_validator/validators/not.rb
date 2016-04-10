module JsonValidator
  module Validators
    class Not < Validator
      type :any

      def validate(record)
        !inner_validator.validate(record)
      end

      def inner_validator
        @inner_validator ||= build_validator(fragment["not"])
      end
    end
  end
end
