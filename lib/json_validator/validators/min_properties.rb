module JsonValidator
  module Validators
    class MinProperties < Validator
      type :object

      def validate(record)
        fragment['minProperties'] <= record.size
      end
    end
  end
end
