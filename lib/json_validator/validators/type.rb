module JsonValidator
  module Validators
    module Type
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        types = Array(schema['type'])
        types.any? {|type| 
          klasses = JsonValidator::TYPES_TO_CLASSES.fetch(type)
          klasses.any? {|klass| record.is_a?(klass)}
        }
      end
    end
  end
end
