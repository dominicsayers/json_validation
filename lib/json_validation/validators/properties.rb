module JsonValidation
  module Validators
    class Properties < Validator
      type :object

      def validate(value, value_path)
        schema['properties'].keys.all? {|key|
          if value[key]
            inner_validators[key].validate(value[key], value_path + [key])
          else
            true
          end
        }
      end

      def validate_with_errors(value, value_path)
        schema['properties'].keys.map {|key|
          if value[key]
            inner_validators[key].validate_with_errors(value[key], value_path + [key])
          else
            nil
          end
        }
      end

      def inner_validators
        @inner_validators ||= Hash[schema['properties'].map {|k, subschema|
          [k, SchemaValidator.new(subschema)]
        }]
      end
    end
  end
end
