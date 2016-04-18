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

      def inner_validators
        @inner_validators ||= Hash[schema['dependencies'].map {|k, f|
          [k, build_validator(f, "dependencies/#{k}")]
        }]
      end
    end
  end
end
