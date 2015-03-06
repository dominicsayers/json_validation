module JsonValidator
  module Validators
    module MaxLength
      extend self
      extend Validator

      type :string

      def validate(schema, record)
        schema['maxLength'] >= record.size
      end
    end
  end
end
