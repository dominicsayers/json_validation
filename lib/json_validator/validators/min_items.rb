module JsonValidator
  module Validators
    class MinItems < Validator
      type :array

      def validate(record)
        fragment['minItems'] <= record.size
      end
    end
  end
end
