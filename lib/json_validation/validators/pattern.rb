module JsonValidation
  module Validators
    class Pattern < Validator
      type :string

      def validate(record)
        rx = Regexp.new(fragment['pattern'])
        !!rx.match(record)
      end
    end
  end
end
