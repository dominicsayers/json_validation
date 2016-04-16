module JsonValidation
  class SchemaValidator
    attr_reader :schema, :base_uri

    def initialize(schema, base_uri)
      @schema = schema

      if schema["id"]
        @base_uri = base_uri.join(Addressable::URI.parse(schema["id"]))
      else
        @base_uri = base_uri
      end
    end

    def validate(record)
      validators.all? {|validator|
        if TYPES_TO_CLASSES[validator.class.type].any? {|klass| record.is_a?(klass)}
          validator.validate(record)
        else
          true
        end
      }
    end

    def validators
      return @validators unless @validators.nil?
      @validators = schema.keys.map {|key|
        if key == '$ref'
          validator_name = 'Ref'
        else
          validator_name = key[0].upcase + key[1..-1]
        end

        begin
          klass = JsonValidation::Validators.const_get(:"#{validator_name}")
        rescue NameError
          nil
        else
          klass.new(schema, base_uri)
        end
      }.compact
    end
  end
end
