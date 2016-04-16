module JsonValidation
  module Validators
    class Enum < Validator
      type :any

      def validate(record)
        schema['enum'].include?(record)
      end
    end
  end
end
