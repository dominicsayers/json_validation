module JsonValidator
  module Validators
    module MultipleOf
      extend self
      extend Validator

      type :number

      def validate(schema, fragment, record)
        BigDecimal.new(record.to_s) % BigDecimal.new(fragment['multipleOf'].to_s) == 0
      end
    end
  end
end
