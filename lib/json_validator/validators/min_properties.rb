module JsonValidator
  module Validators
    module MinProperties
      extend self
      extend Validator

      type :object

      def validate(schema, record)
        schema['minProperties'] <= record.size
      end
    end
  end
end
