module JsonValidator
  module Validators
    module Definitions
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        true # TODO
      end
    end
  end
end
