module JsonValidation
  module Validators
    class Dependencies < Validator
      type :object

      def validate(value, value_path)
        schema['dependencies'].all? {|property, v|
          case v
          when Hash
            dependency_schema = v
            if value.has_key?(property)
              inner_validators[property].validate(value, value_path)
            else
              true
            end
          when Array
            property_set = v
            if value.has_key?(property)
              property_set.all? {|p| value.has_key?(p)}
            else
              true
            end
          else
            raise "Unexpected type for schema['dependencies']['#{property}']"
          end
        }
      end

      def validate_with_errors(value, value_path)
        failures = schema['dependencies'].schema_data.map {|property, v|
          case v
          when Hash
            dependency_schema = v
            if value.has_key?(property)
              inner_validators[property].validate_with_errors(value, value_path)
            else
              nil
            end
          when Array
            property_set = v
            if value.has_key?(property)
              if property_set.all? {|p| value.has_key?(p)}
                nil
              else
                fail_validation(value, value_path)
              end
            else
              nil
            end
          else
            raise "Unexpected type for schema['dependencies']['#{property}']"
          end
        }.flatten.compact

        if failures.any?
          fail_validation(value, value_path, failures)
        else
          nil
        end
      end

      def inner_validators
        @inner_validators ||= Hash[schema['dependencies'].map {|property, subschema|
          [property, SchemaValidator.new(subschema)]
        }]
      end
    end
  end
end
