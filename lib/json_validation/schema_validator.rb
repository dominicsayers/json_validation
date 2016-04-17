module JsonValidation
  class SchemaValidator
    attr_reader :schema, :uri, :base_uri

    def initialize(schema, uri, base_uri)
      @schema = schema
      @uri = uri

      if schema["id"]
        @base_uri = base_uri.join(Addressable::URI.parse(schema["id"]))
      else
        @base_uri = base_uri
      end
    end

    def validate(record)
      validators_for_record(record).all? {|validator|
        validator.validate(record)
      }
    end

    def validate_with_errors(record)
      validators_for_record(record).map {|validator|
        validator.validate_with_errors(record)
      }.flatten.compact
    end

    def validators_for_record(record)
      validators.select {|validator|
        TYPES_TO_CLASSES[validator.class.type].any? {|klass| record.is_a?(klass)}
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
          klass.new(schema, uri, base_uri)
        end
      }.compact
    end
  end
end
