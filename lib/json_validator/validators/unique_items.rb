module JsonValidator
  module Validators
    class UniqueItems < Validator
      type :array

      def validate(record)
        if fragment['uniqueItems']
          record.size == record.uniq.size
        else
          true
        end
      end
    end
  end
end
