module JsonValidator
  module Validators
    module MinItems
      extend self
      extend Validator

      type :array

      def validate(schema, fragment, record)
        fragment['minItems'] <= record.size
      end
    end
  end
end
