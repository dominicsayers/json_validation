module JsonValidator
  module Validators
    class Enum < Validator
      type :any

      def validate(record)
        fragment['enum'].include?(record)
      end
    end
  end
end
