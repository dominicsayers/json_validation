module JsonValidator
  module Validators
    module Pattern
      extend self
      extend Validator

      type :string

      def validate(schema, fragment, record)
        rx = Regexp.new(fragment['pattern'])
        !!rx.match(record)
      end
    end
  end
end
