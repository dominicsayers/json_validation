module JsonValidator
  module Validators
    module PatternProperties
      extend self
      extend Validator

      type :object

      def validate(schema, record)
        schema['patternProperties'].keys.all? {|pattern|
          rx = Regexp.new(pattern)
          record.select {|k, v| rx.match(k)}.all? {|k, v|
            JsonValidator.validate(schema['patternProperties'][pattern], v)
          }
        }
      end
    end
  end
end
