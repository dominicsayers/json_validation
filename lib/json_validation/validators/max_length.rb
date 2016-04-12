module JsonValidation
  module Validators
    class MaxLength < Validator
      type :string

      def validate(record)
        fragment['maxLength'] >= record.size
      end
    end
  end
end
