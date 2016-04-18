module JsonValidation
  module Validators
    class MaxProperties < Validator
      type :object

      def validate(value, value_path)
        schema['maxProperties'] >= value.size
      end
    end
  end
end
