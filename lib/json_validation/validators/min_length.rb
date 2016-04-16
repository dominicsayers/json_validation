module JsonValidation
  module Validators
    class MinLength < Validator
      type :string

      def validate(record)
        schema['minLength'] <= record.size
      end
    end
  end
end
