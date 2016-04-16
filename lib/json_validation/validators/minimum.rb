module JsonValidation
  module Validators
    class Minimum < Validator
      type :number

      def validate(record)
        schema['minimum'] <= record
      end
    end
  end
end
