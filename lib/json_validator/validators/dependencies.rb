module JsonValidator
  module Validators
    module Dependencies
      extend self
      extend Validator

      type :object

      def validate(schema, fragment, record)
        fragment['dependencies'].all? {|property, v|
          case v
          when Hash
            dependency_fragment = v
            if record.has_key?(property)
              JsonValidator.validate(schema, dependency_fragment, record)
            else
              true
            end
          when Array
            property_set = v
            if record.has_key?(property)
              property_set.all? {|p| record.has_key?(p)}
            else
              true
            end
          else
            raise "Unexpected type for fragment['dependencies']['#{property}']"
          end
        }
      end
    end
  end
end
