module JsonValidation
  module Validators
    class MinProperties < Validator
      type :object

      def validate(record)
        schema['minProperties'] <= record.size
      end
    end
  end
end
