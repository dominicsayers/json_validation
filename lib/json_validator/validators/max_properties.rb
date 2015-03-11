module JsonValidator
  module Validators
    module MaxProperties
      extend self
      extend Validator

      type :object

      def validate(schema, fragment, record)
        fragment['maxProperties'] >= record.size
      end
    end
  end
end
