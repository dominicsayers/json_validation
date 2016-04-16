module JsonValidation
  module Validators
    class MultipleOf < Validator
      type :number

      def validate(record)
        BigDecimal.new(record.to_s) % BigDecimal.new(schema['multipleOf'].to_s) == 0
      end
    end
  end
end
