module JsonValidator
  module Validators
    module MinLength
      extend self
      extend Validator

      type :string

      def validate(schema, fragment, record)
        fragment['minLength'] <= record.size
      end
    end
  end
end
