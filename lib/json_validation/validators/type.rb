module JsonValidation
  module Validators
    class Type < Validator
      type :any

      def validate(value, value_path)
        types = Array(schema['type'])
        types.any? {|type| 
          klasses = JsonValidation::TYPES_TO_CLASSES.fetch(type.to_sym)
          klasses.any? {|klass| value.is_a?(klass)}
        }
      end
    end
  end
end
