module JsonValidator
  module Validators
    module MinItems
      extend self
      extend Validator

      type :array

      def validate(schema, record)
        schema['minItems'] <= record.size
      end
    end
  end
end
