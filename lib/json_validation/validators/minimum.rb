module JsonValidation
  module Validators
    class Minimum < Validator
      type :number

      def validate(record)
        fragment['minimum'] <= record
      end
    end
  end
end
