module JsonValidation
  module Validators
    class Pattern < Validator
      type :string

      def validate(value, value_path)
        rx = Regexp.new(schema['pattern'])
        !!rx.match(value)
      end
    end
  end
end
