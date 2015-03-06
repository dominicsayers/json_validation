module JsonValidator
  module Validators
    module MinLength
      extend self
      extend Validator

      type :string

      def validate(schema, record)
        schema['minLength'] <= record.size
      end
    end
  end
end
