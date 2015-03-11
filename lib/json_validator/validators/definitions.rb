module JsonValidator
  module Validators
    module Definitions
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        true # TODO
      end
    end
  end
end
