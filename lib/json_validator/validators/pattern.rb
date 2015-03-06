module JsonValidator
  module Validators
    module Pattern
      extend self
      extend Validator

      type :string

      def validate(schema, record)
        rx = Regexp.new(schema['pattern'])
        !!rx.match(record)
      end
    end
  end
end
