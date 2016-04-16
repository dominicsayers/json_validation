module JsonValidation
  module Validators
    class Pattern < Validator
      type :string

      def validate(record)
        rx = Regexp.new(schema['pattern'])
        !!rx.match(record)
      end
    end
  end
end
