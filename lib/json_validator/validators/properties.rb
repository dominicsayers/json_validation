module JsonValidator
  module Validators
    module Properties
      extend self
      extend Validator

      type :object

      def validate(schema, record)
        schema['properties'].keys.all? {|key|
          if record[key]
            JsonValidator.validate(schema['properties'][key], record[key])
          else
            true
          end
        }
      end
    end
  end
end
