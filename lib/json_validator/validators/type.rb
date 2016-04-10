module JsonValidator
  module Validators
    class Type < Validator
      type :any

      def validate(record)
        types = Array(fragment['type'])
        types.any? {|type| 
          klasses = JsonValidator::TYPES_TO_CLASSES.fetch(type.to_sym)
          klasses.any? {|klass| record.is_a?(klass)}
        }
      end
    end
  end
end
