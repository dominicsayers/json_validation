module JsonValidation
  module Validators
    class MaxItems < Validator
      type :array

      def validate(record)
        schema['maxItems'] >= record.size
      end
    end
  end
end
