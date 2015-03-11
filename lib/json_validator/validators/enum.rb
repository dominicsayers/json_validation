module JsonValidator
  module Validators
    module Enum
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        fragment['enum'].include?(record)
      end
    end
  end
end
