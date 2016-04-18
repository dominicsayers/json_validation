module JsonValidation
  module Validators
    class MinItems < Validator
      type :array

      def validate(value, value_path)
        schema['minItems'] <= value.size
      end
    end
  end
end
