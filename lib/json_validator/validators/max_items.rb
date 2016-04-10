module JsonValidator
  module Validators
    class MaxItems < Validator
      type :array

      def validate(record)
        fragment['maxItems'] >= record.size
      end
    end
  end
end
