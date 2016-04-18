module JsonValidation
  module Validators
    class MaxItems < Validator
      type :array

      def validate(value, value_path)
        schema['maxItems'] >= value.size
      end
    end
  end
end
