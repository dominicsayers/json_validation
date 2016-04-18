module JsonValidation
  module Validators
    class UniqueItems < Validator
      type :array

      def validate(value, value_path)
        value.size == value.uniq.size
      end
    end
  end
end
