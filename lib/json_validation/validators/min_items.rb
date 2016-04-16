module JsonValidation
  module Validators
    class MinItems < Validator
      type :array

      def validate(record)
        schema['minItems'] <= record.size
      end
    end
  end
end
