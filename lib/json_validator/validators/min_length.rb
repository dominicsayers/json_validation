module JsonValidator
  module Validators
    class MinLength < Validator
      type :string

      def validate(record)
        fragment['minLength'] <= record.size
      end
    end
  end
end
