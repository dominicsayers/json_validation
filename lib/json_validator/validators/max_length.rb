module JsonValidator
  module Validators
    module MaxLength
      extend self
      extend Validator

      type :string

      def validate(schema, fragment, record)
        fragment['maxLength'] >= record.size
      end
    end
  end
end
