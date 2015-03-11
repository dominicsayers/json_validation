module JsonValidator
  module Validators
    module Type
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        types = Array(fragment['type'])
        types.any? {|type| 
          klasses = JsonValidator::TYPES_TO_CLASSES.fetch(type)
          klasses.any? {|klass| record.is_a?(klass)}
        }
      end
    end
  end
end
