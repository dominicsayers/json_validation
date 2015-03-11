module JsonValidator
  module Validators
    module MinProperties
      extend self
      extend Validator

      type :object

      def validate(schema, fragment, record)
        fragment['minProperties'] <= record.size
      end
    end
  end
end
