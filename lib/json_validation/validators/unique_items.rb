module JsonValidation
  module Validators
    class UniqueItems < Validator
      type :array

      def validate(record)
        record.size == record.uniq.size
      end
    end
  end
end
